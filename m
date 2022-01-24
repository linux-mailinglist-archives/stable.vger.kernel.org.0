Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB7A498981
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343496AbiAXS4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344263AbiAXSyF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:54:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC11C0613E9;
        Mon, 24 Jan 2022 10:53:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A04C614E3;
        Mon, 24 Jan 2022 18:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D30C340E5;
        Mon, 24 Jan 2022 18:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050389;
        bh=sGOvretFgauqF2/LGbvj1iZr7JxVo+3umuYUrti16Ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dOEMyXdMc+GAwbXcsr7qK+YVSIRsvynzpBmj/4Qq50u08KpAYmNXD79FIiVRGZAW7
         56NHAyXF2ps5H6wYRVaB7UJs2u/I0wQW8Rm19J+/W7/vJFV24demf0IiYvwJ8w7kWm
         o6e4HykwupjITpgzla2MroBLwisd5B1UBgh+2YQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.4 103/114] parisc: pdc_stable: Fix memory leak in pdcs_register_pathentries
Date:   Mon, 24 Jan 2022 19:43:18 +0100
Message-Id: <20220124183930.290507116@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
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
@@ -992,8 +992,10 @@ pdcs_register_pathentries(void)
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


