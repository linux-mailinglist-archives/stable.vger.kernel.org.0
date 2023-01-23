Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E762677712
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 10:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbjAWJJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 04:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbjAWJJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 04:09:27 -0500
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2CE1DBBA
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 01:09:21 -0800 (PST)
Received: by mail-wm1-f53.google.com with SMTP id q10-20020a1cf30a000000b003db0edfdb74so3953608wmq.1
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 01:09:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=H7VWzZglwp8VtodWmsEFkFB/xyPkAohGi1Y4Om69qzkHxB2rc37zIaddF1CqZdbc6f
         f+0n/TZTzASXM4QS33D8enbzzjdxNcSoIt9jWeT0q3mbqfmI0SyN6zsob2eVBhsY7CXc
         zTLzKV8tADcO9Gqt4mPrNvHVKnOdYoZBGZGHs/hQXnccoVt+6Aa9yiR57sQQ/VxFObVj
         N0fI3Iz2Ux1TEJnD9SSTHdkvDbWzeFXeGvk15zmxwQODPv27Wp/M/EzHQnePvLSt+/Bm
         VYkTvnE/e/3Gp+OCFQhk537TWcEIYGA2ywt0LTp7bNkCn4XscW1fE98p/CCqVOTjZrDm
         aofQ==
X-Gm-Message-State: AFqh2kr1SELCjSwvjLyxOLUvrtSzqwp4vTQrQlxjnIWo0dh7S0WUPVAq
        ONK+vcRZSd4ekrwvg2Tr4HI=
X-Google-Smtp-Source: AMrXdXtXvfFYIvhMVFr4PMzRko1dRrWc0YCC3tr9D9pouG7MfIGCOmvnpg43qegDE35rqKhZk8sddQ==
X-Received: by 2002:a05:600c:4928:b0:3d2:2043:9cb7 with SMTP id f40-20020a05600c492800b003d220439cb7mr23216336wmp.5.1674464960394;
        Mon, 23 Jan 2023 01:09:20 -0800 (PST)
Received: from [192.168.64.80] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id q7-20020a05600c46c700b003c6bbe910fdsm12998879wmo.9.2023.01.23.01.09.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 01:09:20 -0800 (PST)
Message-ID: <b5d8df2d-4aae-c3bb-815f-68dbb0165536@grimberg.me>
Date:   Mon, 23 Jan 2023 11:09:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] nvme-fc: Fix initialization order
Content-Language: en-US
To:     Ross Lagerwall <ross.lagerwall@citrix.com>,
        linux-nvme@lists.infradead.org
Cc:     James Smart <james.smart@broadcom.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
References: <20230120174354.3437046-1-ross.lagerwall@citrix.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20230120174354.3437046-1-ross.lagerwall@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
