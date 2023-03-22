Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8E56C444C
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 08:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjCVHq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 03:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCVHq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 03:46:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8A35AB74;
        Wed, 22 Mar 2023 00:46:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78062B81A34;
        Wed, 22 Mar 2023 07:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F176BC433EF;
        Wed, 22 Mar 2023 07:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679471185;
        bh=OcfApPzBhFbVilWX9veIC9cR3TcxTEM6uyoh7NQTV4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ieqy7YeKERD238mqSeqZHh7bdt9fv+09KJAVhevtdiTYCEvGE9yxrzC3swox3JAPb
         NfqyXmLjIqhaRUjmAtqjkMxmhBoozBBh/ukaB8AFPSxzPu5m7aEGgQE9kWjGqtcdQ/
         O/KPhln1Xk/gb2TYzrb97riZItapLy5TVtlRo2Kru2gq6hCpNX6WhkBXUe4kn3asu6
         GpOGzQ6HnmiZRA/KlS74CvuDUQM1gXZWD+Clwx4c3QTltnB4tyRBAEBWl6wiMnYsRW
         7vVaKdsFj5QX3Lv9orvk3bS2n0JOHa1yvyUPBkJty7oI/vRbSvh+RIS3w92sJyGpIA
         EE2WuNkUxPRxA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1petCI-0002Sf-Be; Wed, 22 Mar 2023 08:47:51 +0100
Date:   Wed, 22 Mar 2023 08:47:50 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 05/10] drm/msm: fix drm device leak on bind errors
Message-ID: <ZBqypsYBMSr8HPxP@hovoldconsulting.com>
References: <20230306100722.28485-1-johan+linaro@kernel.org>
 <20230306100722.28485-6-johan+linaro@kernel.org>
 <90264695-131e-46b7-46db-822b0aee9801@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90264695-131e-46b7-46db-822b0aee9801@linaro.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 04:54:51PM +0200, Dmitry Baryshkov wrote:
> On 06/03/2023 12:07, Johan Hovold wrote:
> > Make sure to free the DRM device also in case of early errors during
> > bind().
> > 
> > Fixes: 2027e5b3413d ("drm/msm: Initialize MDSS irq domain at probe time")
> > Cc: stable@vger.kernel.org      # 5.17
> > Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> 
> Can we migrate to devm_drm_dev_alloc instead() ? Will it make code 
> simpler and/or easier to handle?

I'm just fixing the bugs here. Cleanups/rework like that can be done on
top but should not be backported as it risks introducing new issues.

Johan
