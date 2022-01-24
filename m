Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF934498E6D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348143AbiAXTlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:41:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59836 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353888AbiAXTjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:39:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D85BBB81229;
        Mon, 24 Jan 2022 19:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2C3C340E5;
        Mon, 24 Jan 2022 19:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053143;
        bh=x1ittnNsJWwt1zDpNreQd8A+qpmVXaypmHKKZugegkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqBkDYjrtWrcC3YRCwJNbRzKtfFhJ3tfGHF4eNredVWQLfINxwGIbrw5wlyFw17FS
         dXbtDksydOg+iowWt7avfLblP/ohkffcTwocpwvk6Gd/PHV32AtS+oe/O8PiTDWMC7
         O7JBLkX4Q9yjWJZ5HlfKvS8oK4DrioeVexT6qnyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 291/320] parisc: pdc_stable: Fix memory leak in pdcs_register_pathentries
Date:   Mon, 24 Jan 2022 19:44:35 +0100
Message-Id: <20220124184003.848145150@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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


