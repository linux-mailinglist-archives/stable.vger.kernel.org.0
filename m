Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638B16A52F6
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 07:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjB1G1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 01:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjB1G1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 01:27:51 -0500
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D511C5AB;
        Mon, 27 Feb 2023 22:27:50 -0800 (PST)
Received: by mail-wr1-f50.google.com with SMTP id h14so8547156wru.4;
        Mon, 27 Feb 2023 22:27:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qIJwi+ZiA8VVwy9x+m58D44AgNYSEUd57yQq8/pj2Do=;
        b=Jfu3tFg3PHdn60cqb+wh6raCiKx4DKQPOPw0xQERH1TbMuBSAegQeyq8LY8fD1CoR0
         sHvPId8QuGUmfRl78HILA4xjzy2560bmZuL3zrpyIVO5XF1D/dgSFzYd1R1Jl7n//SRG
         /LqzzShO0nSvb0rEjlSZm0CKxPKL/iIuBoK4E4JJPhN4+TagQiJLTgKgDp0r9q4GCRPH
         /kfVxNBAyCpMDhsXJ0NdGtH8aPQxq/BWiUTPlgAwU5CB4yERFtBSJpC90JpqPPFsYaYZ
         f/JNKodR+/qwpnmGTAE3DT/tWHWOGAdVPgge/XmIEBe7RbTFEIijb0Il3R29vnkkNaNe
         YAlg==
X-Gm-Message-State: AO0yUKVp/imAlntSWwok3lT9afU3EzM2UY4SFzWuJv1vTTY4XPR5oqi+
        2ofYJTGfu/A1XwzUaMIfOfQ=
X-Google-Smtp-Source: AK7set/LUYXspeR5E/tlrHvLQ8tqJErH+HXcXcigCbCGOAmCzYVwo2/rmrOY58Bo7AYjP1STyCS1Cw==
X-Received: by 2002:a05:6000:1362:b0:2c7:a9ec:3 with SMTP id q2-20020a056000136200b002c7a9ec0003mr1160384wrz.65.1677565668557;
        Mon, 27 Feb 2023 22:27:48 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:49? ([2a0b:e7c0:0:107::aaaa:49])
        by smtp.gmail.com with ESMTPSA id s8-20020a5d4ec8000000b002c704271b05sm8889896wrv.66.2023.02.27.22.27.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 22:27:48 -0800 (PST)
Message-ID: <e7d9a975-69b8-0290-102e-ac3fce792952@kernel.org>
Date:   Tue, 28 Feb 2023 07:27:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] serial: 8250_fsl: fix handle_irq locking
Content-Language: en-US
To:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Dan Carpenter <error27@gmail.com>
References: <20230227085046.24282-1-johan@kernel.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20230227085046.24282-1-johan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27. 02. 23, 9:50, Johan Hovold wrote:
> The 8250 handle_irq callback is not just called from the interrupt
> handler but also from a timer callback when polling (e.g. for ports
> without an interrupt line). Consequently the callback must explicitly
> disable interrupts to avoid a potential deadlock with another interrupt
> in polled mode.
> 
> Fix up the two paths in the freescale callback that failed to re-enable
> interrupts when polling.

Huh.

Acked-by: Jiri Slaby <jirislaby@kernel.org>

-- 
js
suse labs

