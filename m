Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF036EE4FD
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 17:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbjDYPvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 11:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbjDYPvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 11:51:18 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D71146A1;
        Tue, 25 Apr 2023 08:51:17 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33PFp1KH033567;
        Tue, 25 Apr 2023 10:51:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682437861;
        bh=SSssMoXAAJxbfWfqbEfPrBoPMvhumLnvZAIjsMtep2I=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=bc+/2HovFNrOKwyIOZx8Hb3FS+uopXM8wRW1PpjUBrMJOBG6pjeD8UyuaOyV3XPNr
         PCjM1A+0m1QMUHeg7cRVlxXzr8ttKM0CGQxAvxH8GxtMcvwgithLHjHgTTa/F4YXlu
         vBQa8d0TSc4hDtQrqK4C2d9dOPygXe7qdSooW2Qc=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33PFp1bO028332
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Apr 2023 10:51:01 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 25
 Apr 2023 10:51:01 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 25 Apr 2023 10:51:01 -0500
Received: from localhost (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33PFp1Ej067247;
        Tue, 25 Apr 2023 10:51:01 -0500
Date:   Tue, 25 Apr 2023 10:51:01 -0500
From:   Reid Tonking <reidt@ti.com>
To:     Andi Shyti <andi.shyti@kernel.org>
CC:     <tony@atomide.com>, <vigneshr@ti.com>, <aaro.koskinen@iki.fi>,
        <jmkrzyszt@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH] i2c: omap: Fix standard mode false ACK readings
Message-ID: <20230425155101.qqyvpfjdtqr3tlsh@reidt-t5600.dhcp.ti.com>
References: <20230424195344.627861-1-reidt@ti.com>
 <20230425124549.kdvfyvuy4uolvsr2@intel.intel>
 <20230425145610.j3ljepycclr3i42t@reidt-t5600.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230425145610.j3ljepycclr3i42t@reidt-t5600.dhcp.ti.com>
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a resend to add stable list to cc as well as linux-i2c list
which fell off somehow.

On 09:56-20230425, Reid Tonking wrote:
> Hi Andi,
> 
> On 14:45-20230425, Andi Shyti wrote:
> > Hi Reid,
> > 
> > On Mon, Apr 24, 2023 at 02:53:44PM -0500, Reid Tonking wrote:
> > > Using standard mode, rare false ACK responses were appearing with
> > > i2cdetect tool. This was happening due to NACK interrupt triggering
> > > ISR thread before register access interrupt was ready. Removing the
> > > NACK interrupt's ability to trigger ISR thread lets register access
> > > ready interrupt do this instead.
> > > 
> > > Fixes: 3b2f8f82dad7 ("i2c: omap: switch to threaded IRQ support")
> > > 
> > > Signed-off-by: Reid Tonking <reidt@ti.com>
> > 
> > please don't leave any space between Fixes and SoB.
> > 
> > Add also:
> > 
> > Cc: <stable@vger.kernel.org> # v3.7+
> > 
> > and Cc the stable list.
> > 
> > Andi
> >
> 
> Thanks for the feedback, I'll make that change going forward.
> 
> -Reid

-Reid
