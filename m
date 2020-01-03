Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD92412FE73
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 22:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgACVu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 16:50:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40402 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728657AbgACVu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 16:50:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578088225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2E9jZbURUijwaE1tA6jFTdg/cQa33pnXiVlz2CG9nkU=;
        b=Vi+ebf8/9+UvGWq9WCjk29lyJJChCM9tz1E791OCrgSbMFPOw4tEwlc373KTQAtIjc57W/
        t0jN9trC7wz5TxoUIhqwo6ypyXwMHPyiSAcIfdzXErr94JQ0jr1iSkcSSMuOzTwHteXAMH
        KLIdeDeIoX5rG44k2uGYfd8xovh9Hgg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-UCWFkDf4NoSxSW6p7DXbzQ-1; Fri, 03 Jan 2020 16:50:21 -0500
X-MC-Unique: UCWFkDf4NoSxSW6p7DXbzQ-1
Received: by mail-qk1-f199.google.com with SMTP id f22so6165031qka.10
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 13:50:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=2E9jZbURUijwaE1tA6jFTdg/cQa33pnXiVlz2CG9nkU=;
        b=b0cytqAIjKOdzxSrTeWXKp0+rrZe2z2jkwe7jZkK8ZL7824ukK3OKAuUmU1c8MF2TJ
         fp6q4M7YwsifPOoc5kBDAz0WRRWKDm+9R4vmF5sa0MuawdtInPGXsUZ32YDQpdT/sHxx
         TIzYmuB4dAbkMW8Fvt3k1e1gozIdud8AeHXTtHDdc4tL6ejgrr0O0wwcDfHkfuDtE9wL
         5T7c32NvUAJMitYpF4/PSWq7qpxC9RvuVqjw6z0PYKjDIrCqomdLL4Xc+P4MvqJ7lOYN
         vT/IVGw/tD46mrNWprJwZ1gLV+WVOf3xurHOLO4USxbOMxa7jzswygZ3qJ5u9zLWrVip
         T85A==
X-Gm-Message-State: APjAAAUWbXjb8xfgJ6/SDeq8XsShdFTV4YEf6eHP+uOI+tzr0psVH0Xq
        bRev1Dos21jgt/xag0ypTnwo1F0Y/2fyILPFUDr7Mt342n1GNMvqBOaxKRSn1nfw4U/Gax75WoY
        2RdTocnvIbsxRjf5r
X-Received: by 2002:ad4:5487:: with SMTP id q7mr71109960qvy.19.1578088221270;
        Fri, 03 Jan 2020 13:50:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqzzljP0z5w+OcexEMra3Da+CizoTHREMRArrOSpe2REftTWBrwKU6VuGvcxFXejz+7Ac3I1QA==
X-Received: by 2002:ad4:5487:: with SMTP id q7mr71109951qvy.19.1578088221027;
        Fri, 03 Jan 2020 13:50:21 -0800 (PST)
Received: from dhcp-10-20-1-90.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id 16sm17167452qkj.77.2020.01.03.13.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 13:50:20 -0800 (PST)
Message-ID: <c163a9c8e2f8d71f265a624a1915636acce96b30.camel@redhat.com>
Subject: Re: [PATCH v2] drm/dp_mst: correct the shifting in
 DP_REMOTE_I2C_READ
From:   Lyude Paul <lyude@redhat.com>
To:     Wayne Lin <Wayne.Lin@amd.com>, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org
Cc:     Nicholas.Kazlauskas@amd.com, harry.wentland@amd.com,
        jerry.zuo@amd.com, stable@vger.kernel.org
Date:   Fri, 03 Jan 2020 16:50:19 -0500
In-Reply-To: <20200103055001.10287-1-Wayne.Lin@amd.com>
References: <20200103055001.10287-1-Wayne.Lin@amd.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Lyude Paul <lyude@redhat.com>

Thanks for all of the contributions you've made as of late! I will go ahead
and push this into drm-misc-fixes

On Fri, 2020-01-03 at 13:50 +0800, Wayne Lin wrote:
> [Why]
> According to DP spec, it should shift left 4 digits for NO_STOP_BIT
> in REMOTE_I2C_READ message. Not 5 digits.
> 
> In current code, NO_STOP_BIT is always set to zero which means I2C
> master is always generating a I2C stop at the end of each I2C write
> transaction while handling REMOTE_I2C_READ sideband message. This issue
> might have the generated I2C signal not meeting the requirement. Take
> random read in I2C for instance, I2C master should generate a repeat
> start to start to read data after writing the read address. This issue
> will cause the I2C master to generate a stop-start rather than a
> re-start which is not expected in I2C random read.
> 
> [How]
> Correct the shifting value of NO_STOP_BIT for DP_REMOTE_I2C_READ case in
> drm_dp_encode_sideband_req().
> 
> Changes since v1:(https://patchwork.kernel.org/patch/11312667/)
> * Add more descriptions in commit and cc to stable
> 
> Fixes: ad7f8a1f9ce (drm/helper: add Displayport multi-stream helper (v0.6))
> Reviewed-by: Harry Wentland <harry.wentland@amd.com>
> Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> b/drivers/gpu/drm/drm_dp_mst_topology.c
> index 1cf5f8b8bbb8..9d24c98bece1 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -393,7 +393,7 @@ drm_dp_encode_sideband_req(const struct
> drm_dp_sideband_msg_req_body *req,
>  			memcpy(&buf[idx], req-
> >u.i2c_read.transactions[i].bytes, req-
> >u.i2c_read.transactions[i].num_bytes);
>  			idx += req->u.i2c_read.transactions[i].num_bytes;
>  
> -			buf[idx] = (req-
> >u.i2c_read.transactions[i].no_stop_bit & 0x1) << 5;
> +			buf[idx] = (req-
> >u.i2c_read.transactions[i].no_stop_bit & 0x1) << 4;
>  			buf[idx] |= (req-
> >u.i2c_read.transactions[i].i2c_transaction_delay & 0xf);
>  			idx++;
>  		}
-- 
Cheers,
	Lyude Paul

