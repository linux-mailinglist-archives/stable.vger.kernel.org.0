Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 355892EB05
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfE3DJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:09:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727591AbfE3DJa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:30 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9712C24481;
        Thu, 30 May 2019 03:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185769;
        bh=Q5lSDWobAriHZ4bBwYsgrm/31AWgdhRGttYgtiQ26tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwlmT0FyhpfD+0fA1kPYP6lKUJzfCBfizg9Lg+Eyutew3OS+w92wTiSivVdsdRKbY
         kTTaLuX7DyBK10lK0cvnBUcgy6f9bJLNzQkNfmXZfWwRHlueKkWhZzSebEHDqEdh0U
         ZdFdWmeDccna/YmsGT86DTa4Yr0tIZcC+mAwx58s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Thierry <julien.thierry@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 5.1 020/405] arm64: Kconfig: Make ARM64_PSEUDO_NMI depend on BROKEN for now
Date:   Wed, 29 May 2019 20:00:18 -0700
Message-Id: <20190530030541.616585036@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 96a13f57b946be7a6c10405e4bd780c0b6b6fe63 upstream.

Although we merged support for pseudo-nmi using interrupt priority
masking in 5.1, we've since uncovered a number of non-trivial issues
with the implementation. Although there are patches pending to address
these problems, we're facing issues that prevent us from merging them at
this current time:

  https://lkml.kernel.org/r/1556553607-46531-1-git-send-email-julien.thierry@arm.com

For now, simply mark this optional feature as BROKEN in the hope that we
can fix things properly in the near future.

Cc: <stable@vger.kernel.org> # 5.1
Cc: Julien Thierry <julien.thierry@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1347,6 +1347,7 @@ config ARM64_MODULE_PLTS
 
 config ARM64_PSEUDO_NMI
 	bool "Support for NMI-like interrupts"
+	depends on BROKEN # 1556553607-46531-1-git-send-email-julien.thierry@arm.com
 	select CONFIG_ARM_GIC_V3
 	help
 	  Adds support for mimicking Non-Maskable Interrupts through the use of


