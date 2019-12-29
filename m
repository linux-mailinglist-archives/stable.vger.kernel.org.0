Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92C1D12C85B
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732529AbfL2Rxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:53:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:40928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729371AbfL2Rxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:53:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4F5221D7E;
        Sun, 29 Dec 2019 17:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642024;
        bh=A1FOVV26f2ggY+vCfaKrBDnzf+4YILXKM85+hxAUp5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2j0+/46xjfgoXFXUzMBJmckPqwA5VC1E8OIo30DMp/lsLW67FBAV64pbxnaTs7VY
         P/dmv7UAuxNs2gllxuRHfUzg78QqOPtH0eoEUSp+7N02PKgDajL6IwqLdPxtY3OxTt
         14yUMgopzZmEWkBX8Q7bNorGkmFEdsRHt/enaJKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Xuerui <wangxuerui@qiniu.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 309/434] iwlwifi: mvm: fix unaligned read of rx_pkt_status
Date:   Sun, 29 Dec 2019 18:26:02 +0100
Message-Id: <20191229172722.478297888@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Xuerui <wangxuerui@qiniu.com>

[ Upstream commit c5aaa8be29b25dfe1731e9a8b19fd91b7b789ee3 ]

This is present since the introduction of iwlmvm.
Example stack trace on MIPS:

[<ffffffffc0789328>] iwl_mvm_rx_rx_mpdu+0xa8/0xb88 [iwlmvm]
[<ffffffffc0632b40>] iwl_pcie_rx_handle+0x420/0xc48 [iwlwifi]

Tested with a Wireless AC 7265 for ~6 months, confirmed to fix the
problem. No other unaligned accesses are spotted yet.

Signed-off-by: Wang Xuerui <wangxuerui@qiniu.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 0ad8ed23a455..5ee33c8ae9d2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -60,6 +60,7 @@
  * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *****************************************************************************/
+#include <asm/unaligned.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include "iwl-trans.h"
@@ -357,7 +358,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	rx_res = (struct iwl_rx_mpdu_res_start *)pkt->data;
 	hdr = (struct ieee80211_hdr *)(pkt->data + sizeof(*rx_res));
 	len = le16_to_cpu(rx_res->byte_count);
-	rx_pkt_status = le32_to_cpup((__le32 *)
+	rx_pkt_status = get_unaligned_le32((__le32 *)
 		(pkt->data + sizeof(*rx_res) + len));
 
 	/* Dont use dev_alloc_skb(), we'll have enough headroom once
-- 
2.20.1



