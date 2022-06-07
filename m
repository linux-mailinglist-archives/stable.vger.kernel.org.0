Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39543541024
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352091AbiFGTS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355924AbiFGTRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:17:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C9C3E5F6;
        Tue,  7 Jun 2022 11:08:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4BC5B82340;
        Tue,  7 Jun 2022 18:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E753C385A5;
        Tue,  7 Jun 2022 18:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625269;
        bh=0S9p/Qfh+P5mPbXnyjJNMevBaHDXD81NAZ26hH/OqEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7W/gxSQq65Mc5gCsTE33ZAhitGvLsHQVPaEiAWKUeEt5OB0MJLMpBhbXwzXBmrTE
         sveyfb7DtMAFBtvBjZyblAm/xs3aC0HiAaqsgzC7oRozaMygt/nSDf7D017T6r3cYb
         +Otil8EXGhjpE6xi/S+Z5QqzE60gndn4r/oZraAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 5.15 627/667] carl9170: tx: fix an incorrect use of list iterator
Date:   Tue,  7 Jun 2022 19:04:52 +0200
Message-Id: <20220607164953.473568751@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit 54a6f29522da3c914da30e50721dedf51046449a upstream.

If the previous list_for_each_entry_continue_rcu() don't exit early
(no goto hit inside the loop), the iterator 'cvif' after the loop
will be a bogus pointer to an invalid structure object containing
the HEAD (&ar->vif_list). As a result, the use of 'cvif' after that
will lead to a invalid memory access (i.e., 'cvif->id': the invalid
pointer dereference when return back to/after the callsite in the
carl9170_update_beacon()).

The original intention should have been to return the valid 'cvif'
when found in list, NULL otherwise. So just return NULL when no
entry found, to fix this bug.

Cc: stable@vger.kernel.org
Fixes: 1f1d9654e183c ("carl9170: refactor carl9170_update_beacon")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220328122820.1004-1-xiam0nd.tong@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/carl9170/tx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1558,6 +1558,9 @@ static struct carl9170_vif_info *carl917
 					goto out;
 			}
 		} while (ar->beacon_enabled && i--);
+
+		/* no entry found in list */
+		return NULL;
 	}
 
 out:


