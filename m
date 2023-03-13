Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83366B7239
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 10:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjCMJLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 05:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjCMJL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 05:11:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FF91555E;
        Mon, 13 Mar 2023 02:11:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28F09B80E52;
        Mon, 13 Mar 2023 09:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5D1C433AA;
        Mon, 13 Mar 2023 09:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678698658;
        bh=VBkDDQM5rSgPGIGCsJJS3J32Z4IHiP2wnx+jF9BcaLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AqTaSppKZLz+fCc2kb2M19WsuUYXXZdcuze8MyzhOc0bWK1wo95XUmg0gRfLz8lbA
         I/JVfugX2VkGU9br0TPPd6UiX/v9W0Ff8E1Zj13gYLq4pErKr+0d0I3YcCp6H7ltQH
         H8wp0F2bnVqg1hLZlaGTni4dty2rDAspNxVeMOLXrsaC3mv3rOMPaklXUcpxKvYZPq
         DMlgMdor8zT51X4mu8JybGzYdUVbxTtPSC81pwSZuqwqboWGdLOMifwm+dK2ZOeoCJ
         jZ4E6k8I1UG3iJz/QC7vD6R9Koezn6b1RKP+J3mBRJqICR3zQsp34Id2KDcgoT/N58
         L1JeqBiRU3KmA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pbeDn-0006Wp-4l; Mon, 13 Mar 2023 10:11:59 +0100
Date:   Mon, 13 Mar 2023 10:11:59 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        Georgi Djakov <djakov@kernel.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Yassine Oudjana <y.oudjana@protonmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] interconnect: qcom: rpm: fix msm8996 interconnect
 registration
Message-ID: <ZA7o3zTcFQgTYrZ4@hovoldconsulting.com>
References: <20230313084953.24088-1-johan+linaro@kernel.org>
 <20230313084953.24088-2-johan+linaro@kernel.org>
 <39ada68d-e294-9602-f3f6-506b9a6645d8@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39ada68d-e294-9602-f3f6-506b9a6645d8@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 13, 2023 at 09:57:46AM +0100, Konrad Dybcio wrote:
> On 13.03.2023 09:49, Johan Hovold wrote:
> > A recent commit broke interconnect provider registration for the msm8996
> > platform by accidentally removing a conditional when adding the missing
> > clock disable in the power-domain lookup error path.
> > 
> > Fixes: b6edcc7570b2 ("interconnect: qcom: rpm: fix probe PM domain error handling")
> The hash seems to be different:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djakov/icc.git/commit/?h=icc-next&id=9038710161f0f028e36ef383fca59080f48420ee

Bah, thanks for catching that.

Georgi, can you change this to:

Fixes: a8f1b7ca53c2 ("interconnect: qcom: rpm: fix probe PM domain error handling")

unless you decide to fold this fixup in?

> > Reported-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > Link: https://lore.kernel.org/r/641d04a3-9236-fe76-a20f-11466a01460e@wanadoo.fr
> > Cc: stable@vger.kernel.org      # 5.17
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Johan
