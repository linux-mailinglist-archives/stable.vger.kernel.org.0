Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13094652CFC
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 07:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiLUGnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 01:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLUGnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 01:43:03 -0500
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2521EC71;
        Tue, 20 Dec 2022 22:43:03 -0800 (PST)
Received: by mail-ej1-f47.google.com with SMTP id t17so34601198eju.1;
        Tue, 20 Dec 2022 22:43:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yjzr2jj1F2kUgdqS5ZAf0La7bwTeae6U6bnTXat2Gng=;
        b=NrXVXGDNE3SrlrP5cbAS+yTpW0xynF5pw6/Ye1r2o0McIxx0/iuwN0yxKZ+EwPQuug
         FgxpXM4QnpwMyem1qL7tvfKCBrf54X6GvOj330uO7zouhKHqobhKhOT/PPVnV4Dnhyb9
         KQs1PsxWIuNlCSBDDbWDFtNUcYTzpH//9wST1hXD61thL09xFftBJdTUZ4MH+XVzgbzl
         RzQDuNJ0/hPaUQJjaVHgKcKrC6sv8vwEnavQDmRj7aaN0ywpnXimD+P76C4CgF6k3rRv
         pjHIAYsjaZaNTXYgE+2FZDj/eeYMFF4TSRb1lZZhnAB9NW0708KEdRUUsoN5x9c6mfCe
         Bwqg==
X-Gm-Message-State: AFqh2krj27jttpRJ/En2kdVNAIdjlIZFhYNKPA/5zpa7cbNay8R8dtNb
        cBXAphchFloDxuLiCRp0rCc=
X-Google-Smtp-Source: AMrXdXsKosegsCsvCaudEEkSExyo6mbVSIR4td0ECmmc5bBEC8JdVNAhi4M4j17w0VEGOomIjpwoBA==
X-Received: by 2002:a17:907:d302:b0:7c1:3472:5e75 with SMTP id vg2-20020a170907d30200b007c134725e75mr483043ejc.29.1671604981642;
        Tue, 20 Dec 2022 22:43:01 -0800 (PST)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id e27-20020a170906315b00b007c10d47e748sm6591266eje.36.2022.12.20.22.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 22:43:01 -0800 (PST)
Message-ID: <b21a17c7-df9c-ce20-f986-8f093a33278c@kernel.org>
Date:   Wed, 21 Dec 2022 07:43:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Satya Priya <quic_c_skakit@quicinc.com>,
        linux-arm-msm@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20221220161530.2098299-1-krzysztof.kozlowski@linaro.org>
From:   Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH] tty: serial: qcom-geni-serial: fix slab-out-of-bounds on
 RX FIFO buffer
In-Reply-To: <20221220161530.2098299-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20. 12. 22, 17:15, Krzysztof Kozlowski wrote:
> Driver's probe allocates memory for RX FIFO (port->rx_fifo) based on
> default RX FIFO depth, e.g. 16.  Later during serial startup the
> qcom_geni_serial_port_setup() updates the RX FIFO depth
> (port->rx_fifo_depth) to match real device capabilities, e.g. to 32.
...
> If the RX FIFO depth changes after probe, be sure to resize the buffer.
> 
> Fixes: f9d690b6ece7 ("tty: serial: qcom_geni_serial: Allocate port->rx_fifo buffer in probe")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Jiri Slaby <jirislaby@kernel.org>

This patch LGTM, I only wonder:

> --- a/drivers/tty/serial/qcom_geni_serial.c
> +++ b/drivers/tty/serial/qcom_geni_serial.c
> @@ -864,9 +864,10 @@ static irqreturn_t qcom_geni_serial_isr(int isr, void *dev)
>   	return IRQ_HANDLED;
>   }
>   
> -static void get_tx_fifo_size(struct qcom_geni_serial_port *port)
> +static int get_tx_fifo_size(struct qcom_geni_serial_port *port)

... why is this function dubbed get_tx_fifo_size(), provided it handles 
rx fifo too? And it does not "get" the tx fifo size. In fact, the 
function sets that :).

>   {
>   	struct uart_port *uport;
> +	u32 old_rx_fifo_depth = port->rx_fifo_depth;
>   
>   	uport = &port->uport;
>   	port->tx_fifo_depth = geni_se_get_tx_fifo_depth(&port->se);
> @@ -874,6 +875,16 @@ static void get_tx_fifo_size(struct qcom_geni_serial_port *port)
>   	port->rx_fifo_depth = geni_se_get_rx_fifo_depth(&port->se);
>   	uport->fifosize =
>   		(port->tx_fifo_depth * port->tx_fifo_width) / BITS_PER_BYTE;
> +
> +	if (port->rx_fifo && (old_rx_fifo_depth != port->rx_fifo_depth) && port->rx_fifo_depth) {
> +		port->rx_fifo = devm_krealloc(uport->dev, port->rx_fifo,
> +					      port->rx_fifo_depth * sizeof(u32),
> +					      GFP_KERNEL);

And now it even allocates memory.

So more appropriate name should be setup_fifos() or similar.

> +		if (!port->rx_fifo)
> +			return -ENOMEM;
> +	}
> +
> +	return 0;


-- 
js
suse labs

