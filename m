Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299653DDA17
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbhHBOGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237120AbhHBOEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:04:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FE7A61250;
        Mon,  2 Aug 2021 13:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912681;
        bh=MhNPi2JdnrrlnTq1wlVrt7SFbv/+OFwl/mU8FeAPQOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUsaMqvPvTGWwv0EG7Umcvn/d1tKq4FLRQ65Euer464MgXKXa4S1WyZlNZPsJHlxz
         quHnHR/mBy27JeQRBin7i4OKx2/gIwgnJg2IBBNVGwpmgm6XyMpMchO0sRvH/K+JXX
         66u46JkVBsDO5yVCo3vtBTtW2+4jYvnB38yroxjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 104/104] octeontx2-af: Remove unnecessary devm_kfree
Date:   Mon,  2 Aug 2021 15:45:41 +0200
Message-Id: <20210802134347.420679949@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

commit d72e91efcae12f2f24ced984d00d60517c677857 upstream.

Remove devm_kfree of memory where VLAN entry to RVU PF mapping
info is saved. This will be freed anyway at driver exit.
Having this could result in warning from devm_kfree() if
the memory is not allocated due to errors in rvu_nix_block_init()
before nix_setup_txvlan().

Fixes: 9a946def264d ("octeontx2-af: Modify nix_vtag_cfg mailbox to support TX VTAG entries")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3587,7 +3587,6 @@ static void rvu_nix_block_freemem(struct
 		vlan = &nix_hw->txvlan;
 		kfree(vlan->rsrc.bmap);
 		mutex_destroy(&vlan->rsrc_lock);
-		devm_kfree(rvu->dev, vlan->entry2pfvf_map);
 
 		mcast = &nix_hw->mcast;
 		qmem_free(rvu->dev, mcast->mce_ctx);


