Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC5031132DC
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730664AbfLDSMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:12:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731606AbfLDSMa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:12:30 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5896F20863;
        Wed,  4 Dec 2019 18:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483149;
        bh=CwOyJhYvJ50e9gPlFXRLR7fWplvXt+Ui3hq056Pm6gE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ju2s/qI61IWBauAtE+RBgdlv69ylG/udRv8TSpV8rVZHOQ/KjEFENrTLXeuVT94K7
         ESRi31TDzL75FKOsCaNZvyoW9JcT+7mVRcagGnXxKOeg8jeY2bV23gVnHh1O5O/Eoh
         qQDikqZz9osui+X7MuFZr5bS3h6Aey8hmftAT6XM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 071/125] powerpc/pseries: Fix node leak in update_lmb_associativity_index()
Date:   Wed,  4 Dec 2019 18:56:16 +0100
Message-Id: <20191204175323.343774436@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 47918bc68b7427e961035949cc1501a864578a69 ]

In update_lmb_associativity_index() we lookup dr_node using
of_find_node_by_path() which takes a reference for us. In the
non-error case we forget to drop the reference. Note that
find_aa_index() does modify properties of the node, but doesn't need
an extra reference held once it's returned.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/hotplug-memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 656bbbd731d03..6c12b02f4a61d 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -294,6 +294,7 @@ static u32 lookup_lmb_associativity_index(struct of_drconf_cell *lmb)
 
 	aa_index = find_aa_index(dr_node, ala_prop, lmb_assoc);
 
+	of_node_put(dr_node);
 	dlpar_free_cc_nodes(lmb_node);
 	return aa_index;
 }
-- 
2.20.1



