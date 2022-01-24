Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2261499B27
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574676AbiAXVuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51662 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457005AbiAXVkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:40:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BF7DB80CCF;
        Mon, 24 Jan 2022 21:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73803C340E4;
        Mon, 24 Jan 2022 21:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060440;
        bh=x1ittnNsJWwt1zDpNreQd8A+qpmVXaypmHKKZugegkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bh6g7Swy7+QKD5BvqGnelkT4dWbxl1tArGk37YWxFkrrzccW0ebvR2BSoraRx2xiy
         jzD6Nt/JVdVOIHz43A71pudtjQZpL+Xey0B+Ej4MX/l2K090bIG5khl3U2LKBI24Os
         xdt69CRnriyXuRkUjQ/3+hFsvKOpdNH/L7rmb7I4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.16 0949/1039] parisc: pdc_stable: Fix memory leak in pdcs_register_pathentries
Date:   Mon, 24 Jan 2022 19:45:38 +0100
Message-Id: <20220124184157.188315636@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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


