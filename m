Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 636844CF4A3
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236449AbiCGJUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236412AbiCGJU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:20:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1353C51312;
        Mon,  7 Mar 2022 01:19:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A418AB810BF;
        Mon,  7 Mar 2022 09:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0127C340E9;
        Mon,  7 Mar 2022 09:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646644771;
        bh=EKlNeRm8n7rn3wTopxpaOhV7jlkMIUFOoC8L4W+BktQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+ESyYl8IP5PEchnMX9IXKmj265jbseNAoDAhwCJDb2uLKm/5fn6ahA93tt35V8T5
         Bc59CLQjXd1J1rbpZVeP2fOq4yp1q6tymV39jhnDCeib2xvvocNtvVG3eyBbxdqKzY
         VVSWuQb2uXnNXcsAwca1zjhycH/bqkDWcZ6Eye1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 17/32] firmware: Fix a reference count leak.
Date:   Mon,  7 Mar 2022 10:18:43 +0100
Message-Id: <20220307091634.929397930@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091634.434478485@linuxfoundation.org>
References: <20220307091634.434478485@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

commit fe3c60684377d5ad9b0569b87ed3e26e12c8173b upstream.

kobject_init_and_add() takes reference even when it fails.
If this function returns an error, kobject_put() must be called to
properly clean up the memory associated with the object.
Callback function fw_cfg_sysfs_release_entry() in kobject_put()
can handle the pointer "entry" properly.

Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Link: https://lore.kernel.org/r/20200613190533.15712-1-wu000273@umn.edu
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/qemu_fw_cfg.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/firmware/qemu_fw_cfg.c
+++ b/drivers/firmware/qemu_fw_cfg.c
@@ -461,8 +461,10 @@ static int fw_cfg_register_file(const st
 	/* register entry under "/sys/firmware/qemu_fw_cfg/by_key/" */
 	err = kobject_init_and_add(&entry->kobj, &fw_cfg_sysfs_entry_ktype,
 				   fw_cfg_sel_ko, "%d", entry->f.select);
-	if (err)
-		goto err_register;
+	if (err) {
+		kobject_put(&entry->kobj);
+		return err;
+	}
 
 	/* add raw binary content access */
 	err = sysfs_create_bin_file(&entry->kobj, &fw_cfg_sysfs_attr_raw);
@@ -478,7 +480,6 @@ static int fw_cfg_register_file(const st
 
 err_add_raw:
 	kobject_del(&entry->kobj);
-err_register:
 	kfree(entry);
 	return err;
 }


