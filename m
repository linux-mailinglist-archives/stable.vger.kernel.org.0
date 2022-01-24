Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B75499D83
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356795AbiAXWYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583332AbiAXWRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:17:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492AEC0613A0;
        Mon, 24 Jan 2022 12:48:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D93A060F54;
        Mon, 24 Jan 2022 20:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE361C340E7;
        Mon, 24 Jan 2022 20:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057322;
        bh=x1ittnNsJWwt1zDpNreQd8A+qpmVXaypmHKKZugegkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZ4ArYuB9T4b0bx0JEfxDhTLguJTgNSOANWXI4oz4DKuP4fGetEuMuw9WCUqV/VTm
         CSZjp/CrPH61alOdz6Y6siZzsrH7EUU1plOIuELPBlDFXcR55AfpjxB8kN8+x3y1nR
         8F37/gOe8yLS2LECx/kSb3Ri6t3ekSpWOUB6FIzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 774/846] parisc: pdc_stable: Fix memory leak in pdcs_register_pathentries
Date:   Mon, 24 Jan 2022 19:44:51 +0100
Message-Id: <20220124184127.661919511@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit d24846a4246b6e61ecbd036880a4adf61681d241 upstream.

kobject_init_and_add() takes reference even when it fails.
According to the doc of kobject_init_and_add()：

   If this function returns an error, kobject_put() must be called to
   properly clean up the memory associated with the object.

Fix memory leak by calling kobject_put().

Fixes: 73f368cf679b ("Kobject: change drivers/parisc/pdc_stable.c to use kobject_init_and_add")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/pdc_stable.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/parisc/pdc_stable.c
+++ b/drivers/parisc/pdc_stable.c
@@ -979,8 +979,10 @@ pdcs_register_pathentries(void)
 		entry->kobj.kset = paths_kset;
 		err = kobject_init_and_add(&entry->kobj, &ktype_pdcspath, NULL,
 					   "%s", entry->name);
-		if (err)
+		if (err) {
+			kobject_put(&entry->kobj);
 			return err;
+		}
 
 		/* kobject is now registered */
 		write_lock(&entry->rw_lock);


