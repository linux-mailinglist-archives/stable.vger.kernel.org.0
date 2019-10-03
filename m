Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 695E2CA296
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732850AbfJCQG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732847AbfJCQGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:06:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F352215EA;
        Thu,  3 Oct 2019 16:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118815;
        bh=W/MQtJc3HNF8IPyUepQOWlDMkAdB3bVfVEgqHk2M5u0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVxOKL3/Icl4kYvWeNhKD1ECXxYkWrflId52G1ZdVPMqiM4GtM1cGLaWFoYVA9/U2
         CP9lwvqzNHnygqAXENu3+k6QDsgvmuNNwT/46I1AfDI0gWwpyUnbU1oAvFrXyFnmhs
         AEuOc0sDgjRVkv4H1poUqIhuWeJB/XKEYriGCuEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 002/185] powerpc/xive: Fix bogus error code returned by OPAL
Date:   Thu,  3 Oct 2019 17:51:20 +0200
Message-Id: <20191003154437.856017779@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kurz <groug@kaod.org>

commit 6ccb4ac2bf8a35c694ead92f8ac5530a16e8f2c8 upstream.

There's a bug in skiboot that causes the OPAL_XIVE_ALLOCATE_IRQ call
to return the 32-bit value 0xffffffff when OPAL has run out of IRQs.
Unfortunatelty, OPAL return values are signed 64-bit entities and
errors are supposed to be negative. If that happens, the linux code
confusingly treats 0xffffffff as a valid IRQ number and panics at some
point.

A fix was recently merged in skiboot:

e97391ae2bb5 ("xive: fix return value of opal_xive_allocate_irq()")

but we need a workaround anyway to support older skiboots already
in the field.

Internally convert 0xffffffff to OPAL_RESOURCE which is the usual error
returned upon resource exhaustion.

Cc: stable@vger.kernel.org # v4.12+
Signed-off-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/156821713818.1985334.14123187368108582810.stgit@bahia.lan
(groug: fix arch/powerpc/platforms/powernv/opal-wrappers.S instead of
        non-existing arch/powerpc/platforms/powernv/opal-call.c)
Signed-off-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/opal.h                |    2 +-
 arch/powerpc/platforms/powernv/opal-wrappers.S |    2 +-
 arch/powerpc/sysdev/xive/native.c              |   11 +++++++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/opal.h
+++ b/arch/powerpc/include/asm/opal.h
@@ -266,7 +266,7 @@ int64_t opal_xive_get_vp_info(uint64_t v
 int64_t opal_xive_set_vp_info(uint64_t vp,
 			      uint64_t flags,
 			      uint64_t report_cl_pair);
-int64_t opal_xive_allocate_irq(uint32_t chip_id);
+int64_t opal_xive_allocate_irq_raw(uint32_t chip_id);
 int64_t opal_xive_free_irq(uint32_t girq);
 int64_t opal_xive_sync(uint32_t type, uint32_t id);
 int64_t opal_xive_dump(uint32_t type, uint32_t id);
--- a/arch/powerpc/platforms/powernv/opal-wrappers.S
+++ b/arch/powerpc/platforms/powernv/opal-wrappers.S
@@ -301,7 +301,7 @@ OPAL_CALL(opal_xive_set_queue_info,		OPA
 OPAL_CALL(opal_xive_donate_page,		OPAL_XIVE_DONATE_PAGE);
 OPAL_CALL(opal_xive_alloc_vp_block,		OPAL_XIVE_ALLOCATE_VP_BLOCK);
 OPAL_CALL(opal_xive_free_vp_block,		OPAL_XIVE_FREE_VP_BLOCK);
-OPAL_CALL(opal_xive_allocate_irq,		OPAL_XIVE_ALLOCATE_IRQ);
+OPAL_CALL(opal_xive_allocate_irq_raw,		OPAL_XIVE_ALLOCATE_IRQ);
 OPAL_CALL(opal_xive_free_irq,			OPAL_XIVE_FREE_IRQ);
 OPAL_CALL(opal_xive_get_vp_info,		OPAL_XIVE_GET_VP_INFO);
 OPAL_CALL(opal_xive_set_vp_info,		OPAL_XIVE_SET_VP_INFO);
--- a/arch/powerpc/sysdev/xive/native.c
+++ b/arch/powerpc/sysdev/xive/native.c
@@ -234,6 +234,17 @@ static bool xive_native_match(struct dev
 	return of_device_is_compatible(node, "ibm,opal-xive-vc");
 }
 
+static s64 opal_xive_allocate_irq(u32 chip_id)
+{
+	s64 irq = opal_xive_allocate_irq_raw(chip_id);
+
+	/*
+	 * Old versions of skiboot can incorrectly return 0xffffffff to
+	 * indicate no space, fix it up here.
+	 */
+	return irq == 0xffffffff ? OPAL_RESOURCE : irq;
+}
+
 #ifdef CONFIG_SMP
 static int xive_native_get_ipi(unsigned int cpu, struct xive_cpu *xc)
 {


