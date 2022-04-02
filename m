Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D95C4F017F
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 14:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239237AbiDBMdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 08:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237010AbiDBMdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 08:33:44 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A88AD4CB7;
        Sat,  2 Apr 2022 05:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=UAVTzm47GD54IBrYkM1lqLNeRH+0NrrAmVtDlVk4ieA=;
        t=1648902712; x=1650112312; b=jhAbOmva7d7IAncDH99kwR4DvSJDZNZ9z/onxKts+iiDxWX
        wc3Dvp2YlINSMZU0VhDd9E1RIwkJd7m6Lp/mXVUaqkwSYLHZk824NqNUyiLyr/I2s96thUETD4DKU
        nWk2eC8L6+1fhx7Dga3NekntSfYz8aVtW4ldHA7nax78VQZUQmo3NASaSMyCg0YaJKdUyHiAEJ1W4
        vc97JyGnThMOR3Mp2KEKZ+zBZN6qKeasrwETPFumY8n1F/L+jODJKDjBzFKp5Zm6NUEqDY7LbeXh6
        pLiaQoUyg12kGjHFPilk6J0XvgSu4oyo2dkgKyaVWzWMMDWVbfAYbTDCgisbo3pw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nacus-003qWH-RX;
        Sat, 02 Apr 2022 14:31:42 +0200
Message-ID: <d04373063ca88490d95101e52cd1b65d123d207e.camel@sipsolutions.net>
Subject: Re: [PATCH v5.18] ath9k: Save rate counts before clearing tx status
 area
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        stable@vger.kernel.org, Peter Seiderer <ps.report@gmx.net>
Date:   Sat, 02 Apr 2022 14:31:41 +0200
In-Reply-To: <20220402122752.2347797-1-toke@toke.dk>
References: <20220402122752.2347797-1-toke@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2022-04-02 at 14:27 +0200, Toke Høiland-Jørgensen wrote:
> 
> @@ -2591,12 +2602,6 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
>  				hw->max_rate_tries;
>  	}
>  
> -	for (i = tx_rateindex + 1; i < hw->max_rates; i++) {

might want to drop that blank line too :)

> -		tx_info->status.rates[i].count = 0;
> -		tx_info->status.rates[i].idx = -1;
> -	}
> -
> -	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
>  }

since there's nothing else.

johannes
