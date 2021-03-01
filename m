Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A97328C82
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240693AbhCASx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:53:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:54120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235960AbhCASq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:46:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 508C964FE3;
        Mon,  1 Mar 2021 17:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618075;
        bh=aorfCsHpkh9ylvQlSx6TyVEKIBH27C58VvVb8wqjNVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GEoQHAbXMm+xZOoBrZYka5VNnU4UeaiXpp1h3uZ0Zg9j0h1TBZH5YRwBqjYZ7gvwX
         jgdFtAgd6DSB9ovgtxvnHtxOrPWA8iSss9m5p40vx/UiJo6Keo/REtkzW0+rIs7JHV
         NVfVWr739TYMPDI2Yqu+GEFrcs1P5V0IWhjJnsd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, qiuguorui1 <qiuguorui1@huawei.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.4 291/340] arm64: kexec_file: fix memory leakage in create_dtb() when fdt_open_into() fails
Date:   Mon,  1 Mar 2021 17:13:55 +0100
Message-Id: <20210301161102.613910343@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: qiuguorui1 <qiuguorui1@huawei.com>

commit 656d1d58d8e0958d372db86c24f0b2ea36f50888 upstream.

in function create_dtb(), if fdt_open_into() fails, we need to vfree
buf before return.

Fixes: 52b2a8af7436 ("arm64: kexec_file: load initrd and device-tree")
Cc: stable@vger.kernel.org # v5.0
Signed-off-by: qiuguorui1 <qiuguorui1@huawei.com>
Link: https://lore.kernel.org/r/20210218125900.6810-1-qiuguorui1@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/machine_kexec_file.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -150,8 +150,10 @@ static int create_dtb(struct kimage *ima
 
 		/* duplicate a device tree blob */
 		ret = fdt_open_into(initial_boot_params, buf, buf_size);
-		if (ret)
+		if (ret) {
+			vfree(buf);
 			return -EINVAL;
+		}
 
 		ret = setup_dtb(image, initrd_load_addr, initrd_len,
 				cmdline, buf);


