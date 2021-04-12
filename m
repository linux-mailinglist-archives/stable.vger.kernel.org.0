Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B63F35BE32
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238772AbhDLI5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238981AbhDLIzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A0C56124A;
        Mon, 12 Apr 2021 08:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217657;
        bh=XzYqd4Wk2MNbI79pscmIUBZKL0rKAEqzneFBph07z/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKfFq6AtMbSmR29ldL7kVNkpjTo1/2dMGphguplgF7hdGfTSZYV57IW9/bEK1AKiY
         OhDhtmIixYESxEJ3OEUiUn6fn09fu1S4YbtDJlzA31hnfAvui+IkbmVl/U13y5tuGb
         bm2wmSrs1rDyTFOzuGhx8pIThaCrO96NdQVeS4Mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/188] remoteproc: qcom: pil_info: avoid 64-bit division
Date:   Mon, 12 Apr 2021 10:40:10 +0200
Message-Id: <20210412084016.838020005@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 7029e783027706b427bbfbdf8558252c1dac6fa0 ]

On 32-bit machines with 64-bit resource_size_t, the driver causes
a link failure because of the 64-bit division:

arm-linux-gnueabi-ld: drivers/remoteproc/qcom_pil_info.o: in function `qcom_pil_info_store':
qcom_pil_info.c:(.text+0x1ec): undefined reference to `__aeabi_uldivmod'

Add a cast to an u32 to avoid this. If the resource exceeds 4GB,
there are bigger problems.

Fixes: 549b67da660d ("remoteproc: qcom: Introduce helper to store pil info in IMEM")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210103135628.3702427-1-arnd@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_pil_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_pil_info.c b/drivers/remoteproc/qcom_pil_info.c
index 5521c4437ffa..7c007dd7b200 100644
--- a/drivers/remoteproc/qcom_pil_info.c
+++ b/drivers/remoteproc/qcom_pil_info.c
@@ -56,7 +56,7 @@ static int qcom_pil_info_init(void)
 	memset_io(base, 0, resource_size(&imem));
 
 	_reloc.base = base;
-	_reloc.num_entries = resource_size(&imem) / PIL_RELOC_ENTRY_SIZE;
+	_reloc.num_entries = (u32)resource_size(&imem) / PIL_RELOC_ENTRY_SIZE;
 
 	return 0;
 }
-- 
2.30.2



