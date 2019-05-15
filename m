Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8FA21F0BE
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731881AbfEOLYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731874AbfEOLYt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:24:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAC3220843;
        Wed, 15 May 2019 11:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919488;
        bh=CwKmjeNc1xs6XBSFabOt0+UWXuBe99oN0HyQ1p5eFkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJsGwV+UxBb1JmJn/UpXUWrdEzDhzohWqAqMByqX33FLEK3HagcbF7rW4zx7AUWJL
         Tn6sPJEllxSPLy2b/eCQsNGJe2/SDuPxztoX4qgy3DvDGMWtq+nbjd4yHa1aNc5l2v
         estynlbh/XBZ7kIRCsEBcr4yo3cL5BzFcMF2NPeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Breno Leitao <leitao@debian.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Joel Stanley <joel@jms.id.au>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Major Hayden <major@redhat.com>
Subject: [PATCH 4.19 087/113] powerpc/64s: Include cpu header
Date:   Wed, 15 May 2019 12:56:18 +0200
Message-Id: <20190515090700.266144541@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Breno Leitao <leitao@debian.org>

commit 42e2acde1237878462b028f5a27d9cc5bea7502c upstream.

Current powerpc security.c file is defining functions, as
cpu_show_meltdown(), cpu_show_spectre_v{1,2} and others, that are being
declared at linux/cpu.h header without including the header file that
contains these declarations.

This is being reported by sparse, which thinks that these functions are
static, due to the lack of declaration:

	arch/powerpc/kernel/security.c:105:9: warning: symbol 'cpu_show_meltdown' was not declared. Should it be static?
	arch/powerpc/kernel/security.c:139:9: warning: symbol 'cpu_show_spectre_v1' was not declared. Should it be static?
	arch/powerpc/kernel/security.c:161:9: warning: symbol 'cpu_show_spectre_v2' was not declared. Should it be static?
	arch/powerpc/kernel/security.c:209:6: warning: symbol 'stf_barrier' was not declared. Should it be static?
	arch/powerpc/kernel/security.c:289:9: warning: symbol 'cpu_show_spec_store_bypass' was not declared. Should it be static?

This patch simply includes the proper header (linux/cpu.h) to match
function definition and declaration.

Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Major Hayden <major@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/security.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -4,6 +4,7 @@
 //
 // Copyright 2018, Michael Ellerman, IBM Corporation.
 
+#include <linux/cpu.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/seq_buf.h>


