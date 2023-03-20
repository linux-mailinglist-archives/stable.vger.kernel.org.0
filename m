Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F15A6C0DB6
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjCTJxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjCTJxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:53:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B47B19AB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679305980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q3Pj/3G+pw/sNJtACsoO/q2uAYR7s0D8aHjD/OdMQHg=;
        b=dHnhnk86yrqmWYL2q8wINHxWrQ8lmplbzMmfQPM8XV7o1eUYjiYNeOwc33CrtlK5lRYvc7
        D4LC6VZ8rwbWj0CZtFqsnwnMwjg6DgVEqVzKBZk/kBAaIb07DJefhGSZri7fco0/mY6tzN
        iYWnKNxfRlo70dsTwEdVgrXrVwn2Zdw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-S_rvm7GsOTOh2t82j4Yvkw-1; Mon, 20 Mar 2023 05:52:59 -0400
X-MC-Unique: S_rvm7GsOTOh2t82j4Yvkw-1
Received: by mail-ed1-f72.google.com with SMTP id r19-20020a50aad3000000b005002e950cd3so16819673edc.11
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:52:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679305977;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q3Pj/3G+pw/sNJtACsoO/q2uAYR7s0D8aHjD/OdMQHg=;
        b=Va5O8SvYX5U+UgCgVchnHwdnw26pffcr1+dEFAvpTJC/WvdtdYCiIzvzwgLMJvf2Sg
         UDcQ9rpk2EEgOkWESiApOtUU5Rusiu+tS7dYr656YTl3GI834k5f0QqjPqTdaJNoeaJI
         icawaQb1MRSfdmGLTsWE5dDFWjbNyX9nBxbcsc7Lak58CHl3AcAulMIWrK+JdIiHGSaU
         cCZP2KMdrGD5QoJk5A1ydLyBG5w+mwulTus/OPo/yCR3qNRWf+c6QkDEHqOCQM7mTUAu
         bnMJlAf8u1Y7T+0XKSzXQTUxDTTs9YusrWkXLA/pjuzZsO87mYN4liyebBIlLiAPPtDF
         9s2Q==
X-Gm-Message-State: AO0yUKXz5AAK617Ej2xuSvuSLEpKSggU9TXsLKejRs6BMPublljY65sw
        +aQLr1QM4+giTeV35z+PdUnRs0zq2KlD5NwQEsBOfkCD68QfSdxIeEiRCOpaoZcWBRin2jrOOsx
        yyQ4U05b7ZSaVIta7M5L6gAq7
X-Received: by 2002:a17:906:1e85:b0:931:1567:f84f with SMTP id e5-20020a1709061e8500b009311567f84fmr7658180ejj.4.1679305976966;
        Mon, 20 Mar 2023 02:52:56 -0700 (PDT)
X-Google-Smtp-Source: AK7set83wgbpdegd2TlXJ3c04BQJtTwdCQY5d7UTH7A95NYc2dSM2iqratMQgySSel+pdRIr9S/3YQ==
X-Received: by 2002:a17:906:1e85:b0:931:1567:f84f with SMTP id e5-20020a1709061e8500b009311567f84fmr7658167ejj.4.1679305976719;
        Mon, 20 Mar 2023 02:52:56 -0700 (PDT)
Received: from [10.40.98.142] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id 12-20020a170906310c00b00926d614b890sm4136143ejx.204.2023.03.20.02.52.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 02:52:56 -0700 (PDT)
Message-ID: <d8e8a1fd-eff9-6095-b69c-465f7d6de6aa@redhat.com>
Date:   Mon, 20 Mar 2023 10:52:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 1/1] serial: 8250: Prevent starting up DMA Rx on THRI
 interrupt
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20230317103034.12881-1-ilpo.jarvinen@linux.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20230317103034.12881-1-ilpo.jarvinen@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3/17/23 11:30, Ilpo Järvinen wrote:
> Hans de Goede reported Bluetooth adapters (HCIs) connected over an UART
> connection failed due corrupted Rx payload. The problem was narrowed
> down to DMA Rx starting on UART_IIR_THRI interrupt. The problem occurs
> despite LSR having DR bit set, which is precondition for attempting to
> start DMA Rx in the first place.
> 
> From a debug patch:
> [x.807834] 8250irq: iir=cc lsr+saved=60 received=0/15 ier=0f dma_t/rx/err=0/0/0
> [x.808676] 8250irq: iir=c2 lsr+saved=61 received=0/0 ier=0f dma_t/rx/err=0/0/0
> [x.808776] 8250irq: iir=cc lsr+saved=60 received=1/12 ier=0d dma_t/rx/err=0/1/0
> [x.808870] Bluetooth: hci0: Frame reassembly failed (-84)
> 
> In the debug snippet, received field indicates 1 byte was transferred
> over DMA and 12 bytes after that with the non-DMA Rx. The sole byte DMA
> handled was corrupted (gets zeroed) which leads to the HCI failure.
> 
> This problem became apparent after commit e8ffbb71f783 ("serial: 8250:
> use THRE & __stop_tx also with DMA") changed Tx stop behavior. Tx stop
> is now triggered from a THRI interrupt.
> 
> Despite that this problem looks like a HW bug, this fix is not adding
> UART_BUG_xx flag to the driver beucase it seems useful in general to
> avoid starting DMA when there are only a few bytes to transfer.
> Skipping DMA for small transfers avoids the extra overhead DMA incurs.
> 
> Thus, don't setup DMA Rx on UART_IIR_THRI but leave it to a subsequent
> interrupt which has Rx a related IIR value.
> 
> By returning false from handle_rx_dma(), the DMA vs non-DMA decision is
> postponed until either UART_IIR_RDI (FIFO threshold worth of bytes
> awaiting) or UART_IIR_TIMEOUT (inter-character timeout) triggers at a
> later time which allows better to discern whether the number of bytes
> warrants starting DMA or not.
> 
> Reported-by: Hans de Goede <hdegoede@redhat.com>
> Tested-by: Hans de Goede <hdegoede@redhat.com>
> Fixes: e8ffbb71f783 ("serial: 8250: use THRE & __stop_tx also with DMA")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

Thanks, patch looks good to me:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

> ---
>  drivers/tty/serial/8250/8250_port.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
> index fa43df05342b..3ba9c8b93ae6 100644
> --- a/drivers/tty/serial/8250/8250_port.c
> +++ b/drivers/tty/serial/8250/8250_port.c
> @@ -1903,6 +1903,17 @@ EXPORT_SYMBOL_GPL(serial8250_modem_status);
>  static bool handle_rx_dma(struct uart_8250_port *up, unsigned int iir)
>  {
>  	switch (iir & 0x3f) {
> +	case UART_IIR_THRI:
> +		/*
> +		 * Postpone DMA or not decision to IIR_RDI or IIR_RX_TIMEOUT
> +		 * because it's impossible to do an informed decision about
> +		 * that with IIR_THRI.
> +		 *
> +		 * This also fixes one known DMA Rx corruption issue where
> +		 * DR is asserted but DMA Rx only gets a corrupted zero byte
> +		 * (too early DR?).
> +		 */
> +		return false;
>  	case UART_IIR_RDI:
>  		if (!up->dma->rx_running)
>  			break;

