Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7AF663E2D
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 11:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbjAJK2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 05:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjAJK2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 05:28:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1ED30576
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 02:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673346481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9KIby0sHbh660F6W00pOyfjQiD0YxkgesI7WCpTcF84=;
        b=OHSW/Bl4vufrGdy49ngsVXYSzfspjgHb4UbAOB+4SguVVA/jfn7inVd7qc1Z8h+5rUlMsm
        dfnzQ3fAuIL9EwvarTbUV7P5ZYfTNOLBShwf7H9cdKL8Bvzb0lC+Ie1CCZu0o/M6q8GIqo
        CMjlIjihqsOmX+/uOmS7mhe9bguyP2w=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-139-qsXxLOiQMnymeK7n1KdCYw-1; Tue, 10 Jan 2023 05:27:52 -0500
X-MC-Unique: qsXxLOiQMnymeK7n1KdCYw-1
Received: by mail-qk1-f199.google.com with SMTP id bi3-20020a05620a318300b00702545f73d5so8367016qkb.8
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 02:27:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9KIby0sHbh660F6W00pOyfjQiD0YxkgesI7WCpTcF84=;
        b=TeP2sCWxFLIV3vzKcfw1Apnc44cdGze1AdxFAMtHqD3r6E8tFJSj4RrzkDsoiMsPo1
         6UGbt3sQUpefI8JMmva+h1zXiR3VA/hUkicqadxIww66AihDTvFpqweiL4RYCNiLVik7
         q+e+ZrUOFGdl2j4lUZC5Ncq78nqg47SrZUPgeFtOCvT2SAPGdvEkeA7umcFMcEfvfnL1
         YnjEdKou/l/sU6AoJrWAkTPghIOyxTBaQyFToIla36fosV7BwRr3b6YfhaueSRS8u0cZ
         7LFvW8PC1KDfRnlMPR6tRcNHLmRHbCHna7BBb7mSmtT7WdlwGma+yUPBfRn+vUq8oPDr
         3rWQ==
X-Gm-Message-State: AFqh2krN9/fKfTCdl81Zzxp94i3LmwLoH6p26VB/QTqRpOb8q7OjAmVm
        7GpRjECopuOU6ZoLBcCImxfMOP4mlIAyaohqiBdDonLyfw9kgBjKq3jDYcykNEK3I7IhOnXhek2
        blTMEKJVLkHKAu/OV
X-Received: by 2002:ac8:546:0:b0:3a9:9218:e110 with SMTP id c6-20020ac80546000000b003a99218e110mr96438690qth.37.1673346472290;
        Tue, 10 Jan 2023 02:27:52 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtNbXuxMZfi5jwcdohKmvDBprOB9kZdOoqzZtAC3vlZswt2hulAE8XHX60Y529sh9eOWOGAVg==
X-Received: by 2002:ac8:546:0:b0:3a9:9218:e110 with SMTP id c6-20020ac80546000000b003a99218e110mr96438670qth.37.1673346472039;
        Tue, 10 Jan 2023 02:27:52 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-128.dyn.eolo.it. [146.241.120.128])
        by smtp.gmail.com with ESMTPSA id a19-20020ac81093000000b0039a610a04b1sm5804132qtj.37.2023.01.10.02.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 02:27:51 -0800 (PST)
Message-ID: <b87cdb13baab2a02be2fb3ffc54c581d097cbe7d.camel@redhat.com>
Subject: Re: [PATCH net 1/1] net: stmmac: add aux timestamps fifo clearance
 wait
From:   Paolo Abeni <pabeni@redhat.com>
To:     Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Noor Azura Ahmad Tarmizi 
        <noor.azura.ahmad.tarmizi@linux.intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        stable@vger.kernel.org
Date:   Tue, 10 Jan 2023 11:27:47 +0100
In-Reply-To: <20230109151546.26247-1-noor.azura.ahmad.tarmizi@intel.com>
References: <20230109151546.26247-1-noor.azura.ahmad.tarmizi@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2023-01-09 at 23:15 +0800, Noor Azura Ahmad Tarmizi wrote:
> Add timeout polling wait for auxiliary timestamps snapshot FIFO clear bit
> (ATSFC) to clear. This is to ensure no residue fifo value is being read
> erroneously.
> 
> Cc: <stable@vger.kernel.org> # 5.10.x
> Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>

Please post a new revision of this patch including a suitable 'Fixes'
tag, thanks!

Paolo

