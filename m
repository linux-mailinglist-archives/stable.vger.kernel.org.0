Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7563CDE74
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344980AbhGSPDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344762AbhGSPBI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:01:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A65D361003;
        Mon, 19 Jul 2021 15:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709306;
        bh=olyDjE2D53U+4YbHBN/EaMbR1X0nVqz1klnU62fx4Zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VAkezbAN8o7i8yGDpya3rsGrGHcKWiW/rQG3RSmVo/oEYYf60S6QcKfoEgY99JPAb
         r1VnLyw6gycULZa0bLJnFZVR7AAOYnM80hIEnZMhtd+5FYzKITx7FeC2Fbnir2ii9q
         K24CVGXPno5qoI7h1awBA70LUs7mYIcD4b2AOemA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.19 297/421] qemu_fw_cfg: Make fw_cfg_rev_attr a proper kobj_attribute
Date:   Mon, 19 Jul 2021 16:51:48 +0200
Message-Id: <20210719144956.619299585@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit fca41af18e10318e4de090db47d9fa7169e1bf2f upstream.

fw_cfg_showrev() is called by an indirect call in kobj_attr_show(),
which violates clang's CFI checking because fw_cfg_showrev()'s second
parameter is 'struct attribute', whereas the ->show() member of 'struct
kobj_structure' expects the second parameter to be of type 'struct
kobj_attribute'.

$ cat /sys/firmware/qemu_fw_cfg/rev
3

$ dmesg | grep "CFI failure"
[   26.016832] CFI failure (target: fw_cfg_showrev+0x0/0x8):

Fix this by converting fw_cfg_rev_attr to 'struct kobj_attribute' where
this would have been caught automatically by the incompatible pointer
types compiler warning. Update fw_cfg_showrev() accordingly.

Fixes: 75f3e8e47f38 ("firmware: introduce sysfs driver for QEMU's fw_cfg device")
Link: https://github.com/ClangBuiltLinux/linux/issues/1299
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210211194258.4137998-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/qemu_fw_cfg.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/firmware/qemu_fw_cfg.c
+++ b/drivers/firmware/qemu_fw_cfg.c
@@ -296,15 +296,13 @@ static int fw_cfg_do_platform_probe(stru
 	return 0;
 }
 
-static ssize_t fw_cfg_showrev(struct kobject *k, struct attribute *a, char *buf)
+static ssize_t fw_cfg_showrev(struct kobject *k, struct kobj_attribute *a,
+			      char *buf)
 {
 	return sprintf(buf, "%u\n", fw_cfg_rev);
 }
 
-static const struct {
-	struct attribute attr;
-	ssize_t (*show)(struct kobject *k, struct attribute *a, char *buf);
-} fw_cfg_rev_attr = {
+static const struct kobj_attribute fw_cfg_rev_attr = {
 	.attr = { .name = "rev", .mode = S_IRUSR },
 	.show = fw_cfg_showrev,
 };


