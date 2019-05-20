Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 062232371D
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388148AbfETMVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388147AbfETMVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:21:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C62A8213F2;
        Mon, 20 May 2019 12:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354882;
        bh=any/DlHXg37Ff7AbRPFC1GetjoVK2j3ZkSLPNafzbrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEj1lFCvBRj8g1BXD6J2fs6h2KSyQaRnSEPswQgEB8+Xo24s9SmBMX6Tlg37hYxwS
         d8ouxJ1G/ySUeabvIB6xZy6Z3cRA/I93+kvXgCz2wOF7VYqhuXpSgYnrJpPZRDnw8L
         tOMYm/cBTLrMXsP09LYIhVTgtTZEXhgtsLec0u90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 4.19 015/105] arm64: Clear OSDLR_EL1 on CPU boot
Date:   Mon, 20 May 2019 14:13:21 +0200
Message-Id: <20190520115248.079427103@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

commit 6fda41bf12615ee7c3ddac88155099b1a8cf8d00 upstream.

Some firmwares may reboot CPUs with OS Double Lock set. Make sure that
it is unlocked, in order to use debug exceptions.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/debug-monitors.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -135,6 +135,7 @@ NOKPROBE_SYMBOL(disable_debug_monitors);
  */
 static int clear_os_lock(unsigned int cpu)
 {
+	write_sysreg(0, osdlr_el1);
 	write_sysreg(0, oslar_el1);
 	isb();
 	return 0;


