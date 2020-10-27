Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8187829B4FD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1789490AbgJ0PHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1789747AbgJ0PCo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:02:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 229D521556;
        Tue, 27 Oct 2020 15:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810964;
        bh=mlBNBUT6nslyv3He4klUS121kRNBOHMWavGMQwynaTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XGB2XtbYUIdGDyj1Owj8h9142xjE5Q7ONbjtehbgUUgTBzh2uW7jf++yaeymOk3Bc
         0g5y6u4bGuSB1M13+4RnAs1DbiDw6dKCwaCA289fvCb5PeZ6R4ian6LhOzy9V/mxRk
         +/JvrURLowH9/YI9tKJ84E8h4PWcXKpGZQfZimWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 326/633] powerpc/icp-hv: Fix missing of_node_put() in success path
Date:   Tue, 27 Oct 2020 14:51:09 +0100
Message-Id: <20201027135537.974005442@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Mc Guire <hofrat@osadl.org>

[ Upstream commit d3e669f31ec35856f5e85df9224ede5bdbf1bc7b ]

Both of_find_compatible_node() and of_find_node_by_type() will return
a refcounted node on success - thus for the success path the node must
be explicitly released with a of_node_put().

Fixes: 0b05ac6e2480 ("powerpc/xics: Rewrite XICS driver")
Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1530691407-3991-1-git-send-email-hofrat@osadl.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xics/icp-hv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/sysdev/xics/icp-hv.c b/arch/powerpc/sysdev/xics/icp-hv.c
index ad8117148ea3b..21b9d1bf39ff6 100644
--- a/arch/powerpc/sysdev/xics/icp-hv.c
+++ b/arch/powerpc/sysdev/xics/icp-hv.c
@@ -174,6 +174,7 @@ int icp_hv_init(void)
 
 	icp_ops = &icp_hv_ops;
 
+	of_node_put(np);
 	return 0;
 }
 
-- 
2.25.1



