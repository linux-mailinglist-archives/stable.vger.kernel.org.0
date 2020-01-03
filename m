Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF2312FE8B
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 23:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbgACWCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 17:02:05 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26340 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728657AbgACWCF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 17:02:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578088923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NbgRWeKkmMRYJFDge4YC+wmlH5ur2rHgXJlYcu20mgI=;
        b=HvuNYN9/mQb+X2KSyLYS5PvjsUIkcwySM18CAJDyCZxYZMM/JGdWL4xGAotvQ07A2JRmMK
        SQOHbL+ctTc3zhtXYk750sLHKoPuX1KCcdDCX71m1EvREgCc5No7TsP4kXiViwTKtqHr+c
        B4/NswLiNDz7qyplegD5OKsqvukHkmM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-oY4lfmiuMs2NhudrWjZwlA-1; Fri, 03 Jan 2020 17:02:02 -0500
X-MC-Unique: oY4lfmiuMs2NhudrWjZwlA-1
Received: by mail-qt1-f200.google.com with SMTP id m18so15191418qtq.8
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 14:02:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=NbgRWeKkmMRYJFDge4YC+wmlH5ur2rHgXJlYcu20mgI=;
        b=CP7EdSDijgpWYY3TrYW8s321C5NBRpMh/qUUTsZfCKtd8M6qiZoNGrZgwrBROHNudX
         aHESbBNOE/GMR5qx7QK/qJHCTX10PDP0LXBH0XZN/PKlsqvvGubzZ2pW+M54OFNx6SdU
         DIR36/rEr/CqFQey0SZEUr+5ixavP97pS2auc2BlNnXj3O1cOTKcI9qLI75pmK4zh74Q
         +Clm2ELyLTuCbVAFSxhcf8RxyDD1fX04kAoHeTpRLYJjxsS7dM56lVBHeLzooR6tzROH
         MdBQlJ2kuzeIXyZa01rqcIEKAdevHsxR93hOYEN/3b7PSZ2oULUFwhw4bHVzxzFAAWIP
         SnFA==
X-Gm-Message-State: APjAAAWfuUiTV7UGXlB1botK7miAxQE6syHnkRioJfcOnwOAfwipBCLF
        4x4yDXx5ECjy+WUbU0WQOV9P3TsMmevFwo5DMDWBce4rOdjhcKgq8UEmiuFuA4ic01EzHq/+aaE
        dPJTgmjY8zE/rypa4
X-Received: by 2002:a05:620a:149b:: with SMTP id w27mr75833053qkj.229.1578088921521;
        Fri, 03 Jan 2020 14:02:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqwUfluq+PONcyFVBW01zMor1T71CL92M508ZrAS/HbYc2deWYqv4kGb1B3Nm/MuWgb9dmHJIw==
X-Received: by 2002:a05:620a:149b:: with SMTP id w27mr75833026qkj.229.1578088921277;
        Fri, 03 Jan 2020 14:02:01 -0800 (PST)
Received: from dhcp-10-20-1-90.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id n129sm17234952qkf.64.2020.01.03.14.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 14:02:00 -0800 (PST)
Message-ID: <246412a450f123e0bbc29c6feb68513cdce2c576.camel@redhat.com>
Subject: Re: [PATCH v2] drm/dp_mst: correct the shifting in
 DP_REMOTE_I2C_READ
From:   Lyude Paul <lyude@redhat.com>
To:     Wayne Lin <Wayne.Lin@amd.com>, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org
Cc:     Nicholas.Kazlauskas@amd.com, harry.wentland@amd.com,
        jerry.zuo@amd.com, stable@vger.kernel.org
Date:   Fri, 03 Jan 2020 17:01:59 -0500
In-Reply-To: <20200103055001.10287-1-Wayne.Lin@amd.com>
References: <20200103055001.10287-1-Wayne.Lin@amd.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Oh! Just a friendly tip, I fixed this before pushing your patch:

➜  drm-maint git:(drm-misc-fixes) dim push
dim: 0b1d54cedbb4 ("drm/dp_mst: correct the shifting in DP_REMOTE_I2C_READ"): Fixes: SHA1 needs at least 12 digits:
dim:     ad7f8a1f9ce (drm/helper: add Displayport multi-stream helper (v0.6))
dim: ERROR: issues in commits detected, aborting

For the future, we have a set of DRM maintainer tools (they're quite useful
for people who aren't maintainers though!) that you can use to make sure your
patch is formatted correctly ahead of time:

https://drm.pages.freedesktop.org/maintainer-tools/dim.html

Particularly useful commands:
 * dim sparse # Checks for trivial code issues, like set but unused variables
 * dim checkpatch # Checks for code style issues
 * dim fixes $COMMIT_ID # Adds an appropriately formatted Fixes: tag
 * dim cite $COMMIT_ID # Adds an appropriately formatted Reference: tag

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

