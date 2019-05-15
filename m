Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1AF1F35D
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbfEOLE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:04:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728537AbfEOLE7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:04:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 665EC2173C;
        Wed, 15 May 2019 11:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918297;
        bh=DWibo/aJh4AAodUHDgO+L5KNjhDwqYb3UZ8Bd9YCGRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5CHwpLiwAoPUPBD0l9/iZs9bJ40qoD3Ev8pwJOdOdjd7rubk4wbCGGi1g4QhdrXI
         i9CfPNHiFE/B/mG8dZvYFEirPXIezs5YQ3I38P1VAld9FupAPAvfP3DQEE5++3CbpC
         bTEE6knLrg9ePFnzjITdmT+6vjeoaNZGHh5AbT28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "linuxppc-dev@ozlabs.org, mpe@ellerman.id.au, Diana Craciun" 
        <diana.craciun@nxp.com>, Michael Ellerman <mpe@ellerman.id.au>,
        Diana Craciun <diana.craciun@nxp.com>
Subject: [PATCH 4.4 081/266] powerpc/fsl: Emulate SPRN_BUCSR register
Date:   Wed, 15 May 2019 12:53:08 +0200
Message-Id: <20190515090725.183169160@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diana Craciun <diana.craciun@nxp.com>

commit 98518c4d8728656db349f875fcbbc7c126d4c973 upstream.

In order to flush the branch predictor the guest kernel performs
writes to the BUCSR register which is hypervisor privilleged. However,
the branch predictor is flushed at each KVM entry, so the branch
predictor has been already flushed, so just return as soon as possible
to guest.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
[mpe: Tweak comment formatting]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/e500_emulate.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/powerpc/kvm/e500_emulate.c
+++ b/arch/powerpc/kvm/e500_emulate.c
@@ -277,6 +277,13 @@ int kvmppc_core_emulate_mtspr_e500(struc
 		vcpu->arch.pwrmgtcr0 = spr_val;
 		break;
 
+	case SPRN_BUCSR:
+		/*
+		 * If we are here, it means that we have already flushed the
+		 * branch predictor, so just return to guest.
+		 */
+		break;
+
 	/* extra exceptions */
 #ifdef CONFIG_SPE_POSSIBLE
 	case SPRN_IVOR32:


