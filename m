Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703E25F7791
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 13:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiJGLjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 07:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiJGLjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 07:39:42 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39343267C;
        Fri,  7 Oct 2022 04:39:39 -0700 (PDT)
Received: from [10.10.2.52] (unknown [10.10.2.52])
        by mail.ispras.ru (Postfix) with ESMTPSA id 20FDE40786C1;
        Fri,  7 Oct 2022 11:39:31 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 20FDE40786C1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1665142772;
        bh=RvDRFB7SscBbOK1M1nysxjqWBWdiGV6sE0yj5LXDjVE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZennULcfIF84ilsFKM4D18KTGziKTajRPxzx/Ji4de+EZdBEH2wJrLiKhv/l7CCRB
         BEB1I2odA0ANYgIIyc/SG5azXw6Jgy+SlMB3ZkFN48PgKzhAqPZiS/g8TVSoyS4WSp
         XyH0UFywDtKsggQ5soqjNAKorOLJL3oU5O175ItA=
Subject: Re: [lvc-project] [PATCH 5.10 1/1] Backport of rpmsg: qcom: glink:
 replace strncpy() with strscpy_pad()
To:     Andrew Chernyakov <acherniakov@astralinux.ru>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     lvc-project@linuxtesting.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        linux-arm-msm@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andy Gross <agross@kernel.org>
References: <20221007104120.75208-1-acherniakov@astralinux.ru>
 <20221007104120.75208-2-acherniakov@astralinux.ru>
From:   Alexey Khoroshilov <khoroshilov@ispras.ru>
Autocrypt: addr=khoroshilov@ispras.ru; prefer-encrypt=mutual; keydata=
 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
 kK2E04Fb+Zk1eJvHYRc=
Message-ID: <d9bf2538-b450-d3ac-0542-8cad4a525f07@ispras.ru>
Date:   Fri, 7 Oct 2022 14:39:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20221007104120.75208-2-acherniakov@astralinux.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: ru-RU
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Andrew,

For backporting patches you should follow the following pattern:

---------------------------------------------
Subject: [PATCH 5.10 1/1] {ORIGINAL COMMIT SUBJECT}

From:  {ORIGINAL AUTHOR EMAIL}

commit {ORIGINAL COMMIT HASH} upstream.

{ORIGINAL COMMIT TEXT INCLUDING ALL SIGGNED_OFF}

Signed-off-by: {YOUR EMAIL}
---
{ORIGINAL PATCH}
---------------------------------------------

e.g.
---------------------------------------------
Subject: [PATCH 5.10 1/1] rpmsg: qcom: glink: replace strncpy() with
strscpy_pad()

From:  Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 766279a8f85df32345dbda03b102ca1ee3d5ddea upstream.

The use of strncpy() is considered deprecated for NUL-terminated
strings[1]. Replace strncpy() with strscpy_pad(), to keep existing
pad-behavior of strncpy, similarly to commit 08de420a8014 ("rpmsg:
glink: Replace strncpy() with strscpy_pad()").  This fixes W=1 warning:

  In function ‘qcom_glink_rx_close’,
    inlined from ‘qcom_glink_work’ at
../drivers/rpmsg/qcom_glink_native.c:1638:4:
  drivers/rpmsg/qcom_glink_native.c:1549:17: warning: ‘strncpy’
specified bound 32 equals destination size [-Wstringop-truncation]
   1549 |                 strncpy(chinfo.name, channel->name,
sizeof(chinfo.name));

[1]
https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link:
https://lore.kernel.org/r/20220519073330.7187-1-krzysztof.kozlowski@linaro.org

Signed-off-by: Andrew Chernyakov <acherniakov@astralinux.ru>
---
.....
---------------------------------------------

Please update the patch according the requirements and resend.

Thank you,
Alexey


On 07.10.2022 13:41, Andrew Chernyakov wrote:
> The use of strncpy() is considered deprecated for NULL-terminated
> strings[1]. Replace strncpy() with strscpy_pad(), to keep existing
> pad-behavior of strncpy, strncpy was found on line 1424 of
> /drivers/rpmsg/qcom_glink_native.c.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Andrew Chernyakov <acherniakov@astralinux.ru>
> ---
>  drivers/rpmsg/qcom_glink_native.c | 2 +-
>  drivers/rpmsg/qcom_smd.c          | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
> index 4840886532ff..66a63b205744 100644
> --- a/drivers/rpmsg/qcom_glink_native.c
> +++ b/drivers/rpmsg/qcom_glink_native.c
> @@ -1424,7 +1424,7 @@ static int qcom_glink_rx_open(struct qcom_glink *glink, unsigned int rcid,
>  		}
>  
>  		rpdev->ept = &channel->ept;
> -		strncpy(rpdev->id.name, name, RPMSG_NAME_SIZE);
> +		strscpy_pad(rpdev->id.name, name, RPMSG_NAME_SIZE);
>  		rpdev->src = RPMSG_ADDR_ANY;
>  		rpdev->dst = RPMSG_ADDR_ANY;
>  		rpdev->ops = &glink_device_ops;
> diff --git a/drivers/rpmsg/qcom_smd.c b/drivers/rpmsg/qcom_smd.c
> index 0b1e853d8c91..b5167ef93abf 100644
> --- a/drivers/rpmsg/qcom_smd.c
> +++ b/drivers/rpmsg/qcom_smd.c
> @@ -1073,7 +1073,7 @@ static int qcom_smd_create_device(struct qcom_smd_channel *channel)
>  
>  	/* Assign public information to the rpmsg_device */
>  	rpdev = &qsdev->rpdev;
> -	strncpy(rpdev->id.name, channel->name, RPMSG_NAME_SIZE);
> +	strscpy_pad(rpdev->id.name, channel->name, RPMSG_NAME_SIZE);
>  	rpdev->src = RPMSG_ADDR_ANY;
>  	rpdev->dst = RPMSG_ADDR_ANY;
>  
> @@ -1304,7 +1304,7 @@ static void qcom_channel_state_worker(struct work_struct *work)
>  
>  		spin_unlock_irqrestore(&edge->channels_lock, flags);
>  
> -		strncpy(chinfo.name, channel->name, sizeof(chinfo.name));
> +		strscpy_pad(chinfo.name, channel->name, sizeof(chinfo.name));
>  		chinfo.src = RPMSG_ADDR_ANY;
>  		chinfo.dst = RPMSG_ADDR_ANY;
>  		rpmsg_unregister_device(&edge->dev, &chinfo);
> 

