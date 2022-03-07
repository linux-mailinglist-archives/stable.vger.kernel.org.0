Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CCB4CF50F
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbiCGJYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237454AbiCGJYF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:24:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A3256759;
        Mon,  7 Mar 2022 01:23:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD7C06112D;
        Mon,  7 Mar 2022 09:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23B2C340F3;
        Mon,  7 Mar 2022 09:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646644991;
        bh=EKlNeRm8n7rn3wTopxpaOhV7jlkMIUFOoC8L4W+BktQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFbEAFw3ToRxea5sbOl8ly7vNtPJ1vzn118uOFPxmxRvCZs5yfMm9fV54lZO2RHiN
         xBYSOP2LlKBxa9pgvHAi7qmHM7XQKCwAz7M5g9NF53c9qZajJshL4vVn/ipZcCJduj
         u50lNdvya0YQo3X/gQ0Y6e6F+J5wR6o8Ru02GAQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 26/42] firmware: Fix a reference count leak.
Date:   Mon,  7 Mar 2022 10:19:00 +0100
Message-Id: <20220307091636.913759960@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.146155347@linuxfoundation.org>
References: <20220307091636.146155347@linuxfoundation.org>
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


