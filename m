Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 278A02EF1E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731934AbfE3DTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:19:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731929AbfE3DTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:32 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09AF52489A;
        Thu, 30 May 2019 03:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186372;
        bh=KrL7jNHeUNOhQrVU7TrhZzZdLPJ2pk9m80GUwf3OYaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vM+1kA9eHJJcrhM/Mt7nawnLehhl01siZmPQOjzliW0T1XWMUv1MiDsrRmxOy8sa+
         I1v3Ul+HPCR7hTjK4d9Jl4EqCe2u04bcsNK6+TlUQ6Y14p3MOn0LNL+7SV8hPAS+Z8
         fdMgU8QyFgGgWbVYmqkGT+PTpNI7hK2cktZxUbxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 129/193] s390: cio: fix cio_irb declaration
Date:   Wed, 29 May 2019 20:06:23 -0700
Message-Id: <20190530030506.433616446@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e91012ee855ad9f5ef2ab106a3de51db93fe4d0c ]

clang points out that the declaration of cio_irb does not match the
definition exactly, it is missing the alignment attribute:

../drivers/s390/cio/cio.c:50:1: warning: section does not match previous declaration [-Wsection]
DEFINE_PER_CPU_ALIGNED(struct irb, cio_irb);
^
../include/linux/percpu-defs.h:150:2: note: expanded from macro 'DEFINE_PER_CPU_ALIGNED'
        DEFINE_PER_CPU_SECTION(type, name, PER_CPU_ALIGNED_SECTION)     \
        ^
../include/linux/percpu-defs.h:93:9: note: expanded from macro 'DEFINE_PER_CPU_SECTION'
        extern __PCPU_ATTRS(sec) __typeof__(type) name;                 \
               ^
../include/linux/percpu-defs.h:49:26: note: expanded from macro '__PCPU_ATTRS'
        __percpu __attribute__((section(PER_CPU_BASE_SECTION sec)))     \
                                ^
../drivers/s390/cio/cio.h:118:1: note: previous attribute is here
DECLARE_PER_CPU(struct irb, cio_irb);
^
../include/linux/percpu-defs.h:111:2: note: expanded from macro 'DECLARE_PER_CPU'
        DECLARE_PER_CPU_SECTION(type, name, "")
        ^
../include/linux/percpu-defs.h:87:9: note: expanded from macro 'DECLARE_PER_CPU_SECTION'
        extern __PCPU_ATTRS(sec) __typeof__(type) name
               ^
../include/linux/percpu-defs.h:49:26: note: expanded from macro '__PCPU_ATTRS'
        __percpu __attribute__((section(PER_CPU_BASE_SECTION sec)))     \
                                ^
Use DECLARE_PER_CPU_ALIGNED() here, to make the two match.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Sebastian Ott <sebott@linux.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/cio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/cio.h b/drivers/s390/cio/cio.h
index 94cd813bdcfef..d23d43cf9cbca 100644
--- a/drivers/s390/cio/cio.h
+++ b/drivers/s390/cio/cio.h
@@ -115,7 +115,7 @@ struct subchannel {
 	struct schib_config config;
 } __attribute__ ((aligned(8)));
 
-DECLARE_PER_CPU(struct irb, cio_irb);
+DECLARE_PER_CPU_ALIGNED(struct irb, cio_irb);
 
 #define to_subchannel(n) container_of(n, struct subchannel, dev)
 
-- 
2.20.1



