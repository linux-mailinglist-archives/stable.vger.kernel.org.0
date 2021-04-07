Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9E5356089
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 03:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbhDGBEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 21:04:20 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:36607 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbhDGBEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 21:04:20 -0400
Received: by mail-pf1-f173.google.com with SMTP id g15so11724384pfq.3
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 18:04:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nrx7vAYL/v9rvNMTti5K1Qo11AwKaoS5LOcemj/8W2U=;
        b=iBhhXk1MxmJ2MYETFtjweYoDthf9zcKNCY1Oq6D/yd3hI5YEQfPi6dOf9c4/Z1GxOS
         OU+7OkQ9tbjsY0D69egOg4/Rz5measmGpVCBM0ocAc6c/7vZ20/m6LLthCkI0QDpFPIb
         GWrT9PmJIE3tG7RYWkzM1YZBwZXo26hZeDQMe6DWmDRcCAmN4XfjZZwcHHSrDRk2nav/
         zBIer05YJtkBWEhQyLJCE5h294govztGKQsyPkF/0dHsgGTqUrvsOC8c07mIE7Nwar6X
         Ji1plQLyUBivF35/QMUu0LYlSMrrGboA70FmfBIC0XEz7DK0N7dQLfDhtY+htXyeMj2z
         FFLA==
X-Gm-Message-State: AOAM531ASgBTK4SXW7AQ6n8DmXTfKLffVAuRZpMHk69iLLfbcorPnEUw
        HVIFyn2MEcXlPKLdGpOwKADeLQGOFSk=
X-Google-Smtp-Source: ABdhPJwwVWKwRWSy9PYi5/d1lPFYyUnpeCqjbdXMS72m+AKyxxRx0TRIxHVn8+G/LtwFjkvMd+dFjg==
X-Received: by 2002:a62:1a08:0:b029:220:da90:9173 with SMTP id a8-20020a621a080000b0290220da909173mr783294pfa.65.1617757451729;
        Tue, 06 Apr 2021 18:04:11 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:3103:b16c:6e5:14e0? ([2601:647:4802:9070:3103:b16c:6e5:14e0])
        by smtp.gmail.com with ESMTPSA id e9sm19464280pgk.69.2021.04.06.18.04.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 18:04:11 -0700 (PDT)
Subject: Re: [PATCH stable/5.4..5.8] nvme-mpath: replace direct_make_request
 with generic_make_request
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org
References: <20210402200841.347696-1-sagi@grimberg.me>
 <YGgG2TAA9TNqM9S6@kroah.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <00e36c71-9f2c-5b38-96fd-3d471382f6ac@grimberg.me>
Date:   Tue, 6 Apr 2021 18:04:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YGgG2TAA9TNqM9S6@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>> Hence, we need to fix all the kernels that were before submit_bio_noacct was
>> introduced.
> 
> Why can we not just add submit_bio_noacct to the 5.4 kernel to correct
> this?  What commit id is that?

Hey Greg,

submit_bio_noacct was applied as part of a rework by Christoph that I
didn't feel was suitable as a stable candidate. The commit-id is:
ed00aabd5eb9fb44d6aff1173234a2e911b9fead
