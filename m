Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57D324F628
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730081AbgHXI4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:56:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730591AbgHXI4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:56:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E9C32072D;
        Mon, 24 Aug 2020 08:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259408;
        bh=riN4z/mrdo2qC42KeSPF/qU3Hm3H0TkNahjQu/VUgaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEIQbF3p1kFhkk/ownDUMOLUphD80DU1A2+7gjYLc4aRQ4uDTu/Veyso/V1pzFxTs
         LEJXDSpiqudOxE0Gzr69ziMiVOtwus+6JRAfvAyHhRWz0DfyZpHO3X6HJnVTe3DRjY
         nBokfkrDoeJyJwKVdX022aaX8G4ssIpLrRsyaFv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/71] s390/runtime_instrumentation: fix storage key handling
Date:   Mon, 24 Aug 2020 10:31:38 +0200
Message-Id: <20200824082358.239813704@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082355.848475917@linuxfoundation.org>
References: <20200824082355.848475917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 9eaba29c7985236e16468f4e6a49cc18cf01443e ]

The key member of the runtime instrumentation control block contains
only the access key, not the complete storage key. Therefore the value
must be shifted by four bits.
Note: this is only relevant for debugging purposes in case somebody
compiles a kernel with a default storage access key set to a value not
equal to zero.

Fixes: e4b8b3f33fca ("s390: add support for runtime instrumentation")
Reported-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/runtime_instr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/runtime_instr.c b/arch/s390/kernel/runtime_instr.c
index 125c7f6e87150..1788a5454b6fc 100644
--- a/arch/s390/kernel/runtime_instr.c
+++ b/arch/s390/kernel/runtime_instr.c
@@ -57,7 +57,7 @@ static void init_runtime_instr_cb(struct runtime_instr_cb *cb)
 	cb->k = 1;
 	cb->ps = 1;
 	cb->pc = 1;
-	cb->key = PAGE_DEFAULT_KEY;
+	cb->key = PAGE_DEFAULT_KEY >> 4;
 	cb->v = 1;
 }
 
-- 
2.25.1



