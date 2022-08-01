Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAE15868AA
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiHALvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbiHALuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:50:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E57940BF0;
        Mon,  1 Aug 2022 04:49:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3447B81055;
        Mon,  1 Aug 2022 11:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8FCC433D7;
        Mon,  1 Aug 2022 11:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354561;
        bh=NxgMr9IOK2r74FmzVfDcwXghgS/ZLi9ZSMBfS4OirPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXKyqGEn+Uak2ciWDp/KIUC0WJ7nXlb1n8z3hPWkGhrp5v5h1SWnVcK24R/JJK+mR
         ynKHJSIYkOhcxIZUU25uVuv7YFdGLb/PU+NY6CQnLZVl2DWhBvjqcFrZTJky7sWcN9
         2x/4CvR0LMgloGMJuoSnoXZ7SCAi+GLNB6tIkT8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.4 09/34] ice: check (DD | EOF) bits on Rx descriptor rather than (EOP | RS)
Date:   Mon,  1 Aug 2022 13:46:49 +0200
Message-Id: <20220801114128.406083028@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114128.025615151@linuxfoundation.org>
References: <20220801114128.025615151@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

commit 283d736ff7c7e96ac5b32c6c0de40372f8eb171e upstream.

Tx side sets EOP and RS bits on descriptors to indicate that a
particular descriptor is the last one and needs to generate an irq when
it was sent. These bits should not be checked on completion path
regardless whether it's the Tx or the Rx. DD bit serves this purpose and
it indicates that a particular descriptor is either for Rx or was
successfully Txed. EOF is also set as loopback test does not xmit
fragmented frames.

Look at (DD | EOF) bits setting in ice_lbtest_receive_frames() instead
of EOP and RS pair.

Fixes: 0e674aeb0b77 ("ice: Add handler for ethtool selftest")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -619,7 +619,8 @@ static int ice_lbtest_receive_frames(str
 		rx_desc = ICE_RX_DESC(rx_ring, i);
 
 		if (!(rx_desc->wb.status_error0 &
-		    cpu_to_le16(ICE_TX_DESC_CMD_EOP | ICE_TX_DESC_CMD_RS)))
+		    (cpu_to_le16(BIT(ICE_RX_FLEX_DESC_STATUS0_DD_S)) |
+		     cpu_to_le16(BIT(ICE_RX_FLEX_DESC_STATUS0_EOF_S)))))
 			continue;
 
 		rx_buf = &rx_ring->rx_buf[i];


