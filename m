Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D107164F67
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 21:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgBSUAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 15:00:55 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40905 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBSUAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 15:00:55 -0500
Received: by mail-ot1-f68.google.com with SMTP id i6so1371172otr.7;
        Wed, 19 Feb 2020 12:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rbzfhK/jC2Hjx/QQwW0R0PHP4IE39wXwzL8O28H7Mr0=;
        b=XVi9HI1VtC7aXIwiJ5lk6mAXxUs+laaTiYTxGwrTWIdajFJvHEoLW+6oId1R7++FR8
         OLvtCjYKBj3x2ZEv+WJ8/t9RxdFU9kzlugrA4Sr4fOkNCrvrgB+4ZtA27kqOkc4BdSay
         S658CcqS4bA3UHL/wawr4VuIuySY3yUr5BjSXXeCU8Q0Yc0+pqBsnSKIAav8D+OknVG+
         0xxaUjMAS/LSuQDLC0tRwTdDbSaR14l8UsKs6oGIUVS8IXaNNVr+TgWIIJASUXhXynmC
         VdHhud7N879Hj1hiIvG+YMLpIF1Jl4o4Qnk1XZFws9iit0X006oTLzfV6ZSCW8QlK+JP
         DuMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=rbzfhK/jC2Hjx/QQwW0R0PHP4IE39wXwzL8O28H7Mr0=;
        b=KbzqZm6YaOT7dOEhth+FNxNFQgdx3goP5Ms5uDxNDlD/EJksCsx4ZEk8Ukc0OSTkSP
         DnH89ZQMI/EZwr241GFUHd84qd1gSN3MRrn31GnP18aYkaR7VuOYzvHJjKMePXKyTpNb
         QfUnbsDHdRRaklxC4W9Cr9TX9cgZYcSuymqsw76d4DCZJqaaRtrzPcZDwr5emllTn2lu
         PQ/sH8SbIkaS3Xl+2T1NPCIDRli2EjzOw7cQ6G+zX8Gdc0Mh4cYZhRWLFGqEcaYyr0/j
         c71nz8WU8QTb+JQedei+x9JLRXz169cuOYIe/GyV9tOSjOZMHiJr5PIaNAt5ml564tOb
         FmSA==
X-Gm-Message-State: APjAAAUE4jDAGBw7AIqlE2pRdnJNGfo9r/4ryU9w5LRn/ygun3SCesvU
        PXEAQFxL+8VUh6GjXwkCaYA=
X-Google-Smtp-Source: APXvYqzNBukV1WVRxTaJfoM3IHZcCL/ybKeKF5Zn14V8vYauuFz5sEVdkeokCjd3wcs++SVooXr+0A==
X-Received: by 2002:a05:6830:1353:: with SMTP id r19mr21370236otq.288.1582142453608;
        Wed, 19 Feb 2020 12:00:53 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id m19sm254578otn.47.2020.02.19.12.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 12:00:53 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>,
        Ashish <ashishkumar.yadav@students.iiserpune.ac.in>
Subject: [PATCH] rtlwifi: rtl8188ee: Fix regression due to commit d1d1a96bdb44
Date:   Wed, 19 Feb 2020 14:00:41 -0600
Message-Id: <20200219200041.22279-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For some unexplained reason, commit d1d1a96bdb44 ("rtlwifi: rtl8188ee:
Remove local configuration variable") broke at least one system. As
the only net effect of the change was to remove 2 bytes from the start
of struct phy_status_rpt, this patch adds 2 bytes of padding at the
beginning of the struct.

Fixes: d1d1a96bdb44 ("rtlwifi: rtl8188ee: Remove local configuration variable")
Cc: Stable <stable@vger.kernel.org>  # V5.4+
Reported-by: Ashish <ashishkumar.yadav@students.iiserpune.ac.in>
Tested-by: Ashish <ashishkumar.yadav@students.iiserpune.ac.in>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h
index 917729807514..e17f70b4d199 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h
@@ -561,6 +561,7 @@ static inline void clear_pci_tx_desc_content(__le32 *__pdesc, int _size)
 	 rxmcs == DESC92C_RATE11M)
 
 struct phy_status_rpt {
+	u8	padding[2];
 	u8	ch_corr[2];
 	u8	cck_sig_qual_ofdm_pwdb_all;
 	u8	cck_agc_rpt_ofdm_cfosho_a;
-- 
2.25.0

