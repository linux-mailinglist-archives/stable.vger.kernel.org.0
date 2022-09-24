Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5F65E8AF3
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 11:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbiIXJeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 05:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbiIXJeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 05:34:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D546112E429;
        Sat, 24 Sep 2022 02:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70CA3608C3;
        Sat, 24 Sep 2022 09:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542DBC433C1;
        Sat, 24 Sep 2022 09:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664012056;
        bh=3mobUcHXtIiwJ/IgBy0YxctGCTuEvcBls7FCY9NGx94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WwI4czSd+PC2k+Gv5uUc0PfQbDuMvfCng+HMUKtnB711hP7bxapr7iMQBnl8KUtev
         GJPt8x3FUhpAgWK2k2xNMhyhiIVvrMUPYzmGcHPTPKCKYrkKosNqQMAkyx4V0NtKj8
         pEgW219IWo2sqggtMPPfTq+vFrA9EleWzOkE7FwY=
Date:   Sat, 24 Sep 2022 11:34:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Elder <elder@linaro.org>
Cc:     Douglas Anderson <dianders@chromium.org>, stable@vger.kernel.org,
        swboyd@chromium.org, Mike Tipton <mdtipton@codeaurora.org>,
        Georgi Djakov <djakov@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Georgi Djakov <georgi.djakov@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [5.10 PATCH] interconnect: qcom: icc-rpmh: Add BCMs to commit
 list in pre_aggregate
Message-ID: <Yy7PFenCa0Sa3B3n@kroah.com>
References: <20220922141725.5.10.1.I791715539cae1355e21827ca738b0b523a4a0f53@changeid>
 <00eb82ca-8bf6-c744-d04d-96b97ce06b17@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00eb82ca-8bf6-c744-d04d-96b97ce06b17@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 04:28:25PM -0500, Alex Elder wrote:
> On 9/22/22 4:18 PM, Douglas Anderson wrote:
> > From: Mike Tipton <mdtipton@codeaurora.org>
> > 
> > commit b95b668eaaa2574e8ee72f143c52075e9955177e upstream.
> > 
> > We're only adding BCMs to the commit list in aggregate(), but there are
> > cases where pre_aggregate() is called without subsequently calling
> > aggregate(). In particular, in icc_sync_state() when a node with initial
> > BW has zero requests. Since BCMs aren't added to the commit list in
> > these cases, we don't actually send the zero BW request to HW. So the
> > resources remain on unnecessarily.
> > 
> > Add BCMs to the commit list in pre_aggregate() instead, which is always
> > called even when there are no requests.
> > 
> > Signed-off-by: Mike Tipton <mdtipton@codeaurora.org>
> > [georgi: remove icc_sync_state for platforms with incomplete support]
> > Link: https://lore.kernel.org/r/20211125174751.25317-1-djakov@kernel.org
> > Signed-off-by: Georgi Djakov <djakov@kernel.org>
> > [dianders: dropped sm8350.c which isn't present in 5.10]
> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> 
> Whoops, sorry about that.
> 
> Acked-by: Alex Elder <elder@linaro.org>

Now queued up, thanks.

greg k-h
