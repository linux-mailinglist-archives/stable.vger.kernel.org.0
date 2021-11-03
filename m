Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAF1443BDC
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 04:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhKCDfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 23:35:12 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:46839 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhKCDfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 23:35:11 -0400
Received: by mail-pj1-f45.google.com with SMTP id x16-20020a17090a789000b001a69735b339so375732pjk.5;
        Tue, 02 Nov 2021 20:32:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=73g9y0UfXxQ4XXYawiggQd6yfsSGt9I1TKhQ5L6aVl8=;
        b=hToOM4pDdsO8rNLxfB0Ss5+lK2D/oQL2kc5P48ZlF3kHW3pQEmdMVnxBhBR8GFPDya
         hSj5xNkpg02pz6mNx77KwC8S51g1uVZcdSIWpqRe6ovxjqNfNePBizp6tT88SZyCWsSa
         GM8tiqU73hjVVUH5Edv1DrEcmZQ3Pes2+fmHC/lKAUhwOCTweSb4TeuMdVGMKlclfRnu
         C8lsw57c59FNeu58tMLkvPPFB61veBB/3uCvV2PyqISyzyeWNMrBWehnFTknoOIaYK5I
         1XtTRFWpnIo6HGm+SI6Nj0e6vb7v2pMv9XtpU5PQ24EOqS3xhArI3cEDfYWzKyLywHCN
         UtLA==
X-Gm-Message-State: AOAM533+jM8lJmk6QE/FFR27qNIThyt3zan4tpI4o7asHjlnu+QJtrwW
        XpOnlXwKbiD1KeSpC5ziQcw=
X-Google-Smtp-Source: ABdhPJzvJm1eQI85KjXzet9IStlsXP5EZYG8FujnOFK4Qf71E7LN1zJmmxiHR3r87yUFXk0sbz9jng==
X-Received: by 2002:a17:90a:4414:: with SMTP id s20mr8570840pjg.132.1635910355387;
        Tue, 02 Nov 2021 20:32:35 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:28c6:b7fe:a27f:fce6? ([2601:647:4000:d7:28c6:b7fe:a27f:fce6])
        by smtp.gmail.com with ESMTPSA id z73sm424964pgz.23.2021.11.02.20.32.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 20:32:34 -0700 (PDT)
Message-ID: <d1259a80-ac2f-a164-685a-4d1763653021@acm.org>
Date:   Tue, 2 Nov 2021 20:32:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 1/2] scsi: scsi_ioctl: Validate command size
Content-Language: en-US
To:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        linux-scsi@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20211103003719.1041490-1-tadeusz.struk@linaro.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211103003719.1041490-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/2/21 17:37, Tadeusz Struk wrote:
> +	if (hdr->cmd_len < 6 || hdr->cmd_len > sizeof(req->__cmd))
> +		return -EMSGSIZE;

That doesn't look right to me since sg_io() allocates req->cmd if necessary:

	if (hdr->cmd_len > BLK_MAX_CDB) {
		req->cmd = kzalloc(hdr->cmd_len, GFP_KERNEL);
		if (!req->cmd)
			goto out_put_request;
	}

Bart.
