Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B1965D8B9
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239853AbjADQRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239759AbjADQR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:17:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FE8112E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:17:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 19717CE184A
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9D9C433D2;
        Wed,  4 Jan 2023 16:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849044;
        bh=28ckKiyj9m0vg3THgDlgJYCvyX5Xu6g7B6dQBS8gd2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTnfd8rTB0nkbSXvABRkWGFn4gPolfFhGtW15d5FvL4f/+nqVKI4LZMPoasTyZK5q
         1/UxMkvM7uIBsq3O4A8m8qYaNniymab8W22mdaOEQNULv+7dU5yZC0EHx13dYTOMoF
         SnC0oObVuguPNX57tvnGdEh5CrqqZk/0rua9lBF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.1 124/207] um: virt-pci: Avoid GCC non-NULL warning
Date:   Wed,  4 Jan 2023 17:06:22 +0100
Message-Id: <20230104160515.842647496@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit bdc77507fecd00ddad2f502f86a48a9ec38f0f84 upstream.

GCC gets confused about the return value of get_cpu_var() possibly
being NULL, so explicitly test for it before calls to memcpy() and
memset(). Avoids warnings like this:

   arch/um/drivers/virt-pci.c: In function 'um_pci_send_cmd':
   include/linux/fortify-string.h:48:33: warning: argument 1 null where non-null expected [-Wnonnull]
      48 | #define __underlying_memcpy     __builtin_memcpy
         |                                 ^
   include/linux/fortify-string.h:438:9: note: in expansion of macro '__underlying_memcpy'
     438 |         __underlying_##op(p, q, __fortify_size);                        \
         |         ^~~~~~~~~~~~~
   include/linux/fortify-string.h:483:26: note: in expansion of macro '__fortify_memcpy_chk'
     483 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
         |                          ^~~~~~~~~~~~~~~~~~~~
   arch/um/drivers/virt-pci.c:100:9: note: in expansion of macro 'memcpy'
     100 |         memcpy(buf, cmd, cmd_size);
         |         ^~~~~~

While at it, avoid literal "8" and use stored sizeof(buf->data) in
memset() and um_pci_send_cmd().

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/202211271212.SUZSC9f9-lkp@intel.com
Fixes: ba38961a069b ("um: Enable FORTIFY_SOURCE")
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: linux-um@lists.infradead.org
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/drivers/virt-pci.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/um/drivers/virt-pci.c
+++ b/arch/um/drivers/virt-pci.c
@@ -97,7 +97,8 @@ static int um_pci_send_cmd(struct um_pci
 	}
 
 	buf = get_cpu_var(um_pci_msg_bufs);
-	memcpy(buf, cmd, cmd_size);
+	if (buf)
+		memcpy(buf, cmd, cmd_size);
 
 	if (posted) {
 		u8 *ncmd = kmalloc(cmd_size + extra_size, GFP_ATOMIC);
@@ -182,6 +183,7 @@ static unsigned long um_pci_cfgspace_rea
 	struct um_pci_message_buffer *buf;
 	u8 *data;
 	unsigned long ret = ULONG_MAX;
+	size_t bytes = sizeof(buf->data);
 
 	if (!dev)
 		return ULONG_MAX;
@@ -189,7 +191,8 @@ static unsigned long um_pci_cfgspace_rea
 	buf = get_cpu_var(um_pci_msg_bufs);
 	data = buf->data;
 
-	memset(buf->data, 0xff, sizeof(buf->data));
+	if (buf)
+		memset(data, 0xff, bytes);
 
 	switch (size) {
 	case 1:
@@ -204,7 +207,7 @@ static unsigned long um_pci_cfgspace_rea
 		goto out;
 	}
 
-	if (um_pci_send_cmd(dev, &hdr, sizeof(hdr), NULL, 0, data, 8))
+	if (um_pci_send_cmd(dev, &hdr, sizeof(hdr), NULL, 0, data, bytes))
 		goto out;
 
 	switch (size) {


