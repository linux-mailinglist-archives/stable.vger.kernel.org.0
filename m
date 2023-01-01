Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5A765A9CB
	for <lists+stable@lfdr.de>; Sun,  1 Jan 2023 12:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjAALmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 06:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjAALmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 06:42:35 -0500
X-Greylist: delayed 359 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 01 Jan 2023 03:42:34 PST
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339135FF6
        for <stable@vger.kernel.org>; Sun,  1 Jan 2023 03:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1672572991;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=uCeod2rK1eavDzGY0W5pX6FcRiXxrx4c4hZhTh6vkjk=;
    b=ikUTO0ourknMQm8iBIL9CgVqe4qOw0jKNR894UXTHze/AGw+JvFpdDIoXhAx82Fy3w
    uPW4RXz+w0ejbqCIob3b4EOdWxCsl5KhPkcEW9v8XHISIFWClXubisHhZhPG7sh2griM
    UBM9jWa2Y1amiCfSwivJz2t29NjTh4EOGdAqvJ6+9yYYyaaqwaXe+kg8dcb/6aftQCud
    tvklODam9qzLx3yrfGqViGIbOYgESwV/oEFOYxHm+V4bAyJbfhERvD3XJoVrmtO853O+
    1wAsFwZSc9AfSQyKIWdI5qZvrGyZMlCSEYhmc+A7LY0R9Xu1AcM/QU5eNt0bcsn24TGR
    vfBg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u261EJF5OxJAhdlWyvDI"
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 48.2.1 DYNA|AUTH)
    with ESMTPSA id Yce349z01BaUbb0
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 1 Jan 2023 12:36:30 +0100 (CET)
Date:   Sun, 1 Jan 2023 12:36:24 +0100
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Brian Norris <computersforpeace@gmail.com>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ASoC: qcom: lpass-cpu: Fix fallback SD line index
 handling
Message-ID: <Y7FwOECdeNhtGbbF@gerhold.net>
References: <20221231061545.2110253-1-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221231061545.2110253-1-computersforpeace@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Brian,

On Fri, Dec 30, 2022 at 10:15:45PM -0800, Brian Norris wrote:
> These indices should reference the ID placed within the dai_driver
> array, not the indices of the array itself.
> 

Indeed, thanks for the fix and sorry for breaking IPQ8064 audio. Looks
like it's not tested very often because my patch that broke it was
merged 2.5 years ago. :-)

> This fixes commit 4ff028f6c108 ("ASoC: qcom: lpass-cpu: Make I2S SD
> lines configurable"), which among others, broke IPQ8064 audio

FWIW I think it's really just IPQ8064 audio (no others) because the
other platforms all happen to have the MI2S ports at the same index as
their ID.

> (sound/soc/qcom/lpass-ipq806x.c) because it uses ID 4 but we'd stop
> initializing the mi2s_playback_sd_mode and mi2s_capture_sd_mode arrays
> at ID 0.
> 
> Fixes: 4ff028f6c108 ("ASoC: qcom: lpass-cpu: Make I2S SD lines configurable")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>

Reviewed-by: Stephan Gerhold <stephan@gerhold.net>

BTW I just found this patch "by accident" while looking for something
else on the stable mailing list. Please Cc the original author if you
use Fixes (get_maintainer.pl should suggest that automatically if you
run it in the kernel tree). :)

Thanks!
Stephan

> ---
>  sound/soc/qcom/lpass-cpu.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
> index 54353842dc07..dbdaaa85ce48 100644
> --- a/sound/soc/qcom/lpass-cpu.c
> +++ b/sound/soc/qcom/lpass-cpu.c
> @@ -1037,10 +1037,11 @@ static void of_lpass_cpu_parse_dai_data(struct device *dev,
>  					struct lpass_data *data)
>  {
>  	struct device_node *node;
> -	int ret, id;
> +	int ret, i, id;
>  
>  	/* Allow all channels by default for backwards compatibility */
> -	for (id = 0; id < data->variant->num_dai; id++) {
> +	for (i = 0; i < data->variant->num_dai; i++) {
> +		id = data->variant->dai_driver[i].id;
>  		data->mi2s_playback_sd_mode[id] = LPAIF_I2SCTL_MODE_8CH;
>  		data->mi2s_capture_sd_mode[id] = LPAIF_I2SCTL_MODE_8CH;
>  	}
> -- 
> 2.39.0
> 
