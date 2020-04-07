Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43CA31A0BD5
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgDGKXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728462AbgDGKX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:23:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E84C820644;
        Tue,  7 Apr 2020 10:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255006;
        bh=5/sL9mCXly5jrq1A3Z9N4VVG6JUPKXdB9TUdv7LPc+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ek2IyiXBFNT7W7bkfcTBGmTOJSdavEoMxf0yghUTc+ALh5xTSkE0sGSg/H2edqhMa
         f0Y8TuwCMiXz7o5sWltYIHqlyVNFhKqFHvGyddHow/VnzJzJ0CdJtUx6PP1PATa/jQ
         swTaaYYmncreKp4b8XWnYO9/uH8nGf8lMLcXHXLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.4 28/36] iwlwifi: consider HE capability when setting LDPC
Date:   Tue,  7 Apr 2020 12:22:01 +0200
Message-Id: <20200407101457.877281841@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101454.281052964@linuxfoundation.org>
References: <20200407101454.281052964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

commit cb377dfda1755b3bc01436755d866c8e5336a762 upstream.

The AP may set the LDPC capability only in HE (IEEE80211_HE_PHY_CAP1),
but we were checking it only in the HT capabilities.

If we don't use this capability when required, the DSP gets the wrong
configuration in HE and doesn't work properly.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Fixes: befebbb30af0 ("iwlwifi: rs: consider LDPC capability in case of HE")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200306151128.492d167c1a25.I1ad1353dbbf6c99ae57814be750f41a1c9f7f4ac@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -147,7 +147,11 @@ static u16 rs_fw_get_config_flags(struct
 	     (vht_ena && (vht_cap->cap & IEEE80211_VHT_CAP_RXLDPC))))
 		flags |= IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK;
 
-	/* consider our LDPC support in case of HE */
+	/* consider LDPC support in case of HE */
+	if (he_cap->has_he && (he_cap->he_cap_elem.phy_cap_info[1] &
+	    IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD))
+		flags |= IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK;
+
 	if (sband->iftype_data && sband->iftype_data->he_cap.has_he &&
 	    !(sband->iftype_data->he_cap.he_cap_elem.phy_cap_info[1] &
 	     IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD))


