Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C863B6AED00
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjCGSAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbjCGR7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:59:31 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1132AA6BC4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:53:57 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-536cb25982eso258138577b3.13
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 09:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678211637;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vy6L+eQJroBciwKL8scsNnpdjChAQfq3YHv0JMCXPSo=;
        b=e5jG2hZtedpCOzEhX3MKhD2DImjqtaX15SiOuwdCp9uhYmlrOC0ZWMmPQPK68zJvoR
         XAj79c72bwCV4qcDZN4rxzSoygjodATifVd6Mk9QlbhHnyrmLohklKUhfg2DZWAly8wV
         6ifUxWO7zlteysiu8qU8w3Z/5p67GRMwD32FqGakfwE1ynRAeOcrN7NtuK/A57l6/VnZ
         JA5CdR256HdyzLj5lvV9ndzOcBthtH44FOfiBa0hqfLztygvBVoP7+VtuCBM2la3+Gum
         8cK2z7glwwN8l9FX080OVnwFSMwEuM2YXUKzFIZ0VA/zUP/6fj+dNkEoc823vHWgyBHR
         x0Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678211637;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vy6L+eQJroBciwKL8scsNnpdjChAQfq3YHv0JMCXPSo=;
        b=YP/SGrHe+YFEXpoojtEprDfHWsrpartu41R04aDwQCmsu8aKvrTVvQQdqtDdZvDyde
         ngxCy0dcyrgnwqvHJ19Creii152/lursHaX0JPwU6wPr30IjyfNLjNxgJb06vXkZRmqR
         eR1gV096KhJECohHRByFauNkVph4MevlGOgijmfgdWsXaApCSFIu3iAecP+/UAOtoE6j
         cumS85vXWjetu+n6NuX69fsFc15+AKEWIF2dY8ATCyQCgOMyxQPnVxo6dx9aE3vLctkF
         /3B9fhNmL3hYWom/X2Zv1UNdanyJQezF1tATsAA6XyUnm/BfU5QbK8rlu/tGUk9MIyyk
         wc0Q==
X-Gm-Message-State: AO0yUKX97aL3C4RQ45ZK5L8ADqLb/utJ4PT+1+X+bLATmRT9Bk5edSS6
        ymTbj09CredMohyPWYPtHK8qQFFJ5vcFQ+1JTSenWHWXpWouDlYr
X-Google-Smtp-Source: AK7set9FjQy7hM69scJN/x0IXxD69J1rqAnvHqJd628maJ126bk1Sb0clpk6+IRyjQ2IH0NlkuU6hicsP0uUb0Jre6E=
X-Received: by 2002:a81:ac59:0:b0:52e:bb3e:15aa with SMTP id
 z25-20020a81ac59000000b0052ebb3e15aamr9163642ywj.7.1678211637049; Tue, 07 Mar
 2023 09:53:57 -0800 (PST)
MIME-Version: 1.0
References: <20230307170022.094103862@linuxfoundation.org> <20230307170043.650684610@linuxfoundation.org>
In-Reply-To: <20230307170043.650684610@linuxfoundation.org>
From:   Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Date:   Tue, 7 Mar 2023 18:53:46 +0100
Message-ID: <CACMJSetcAiz6nwCdAuZekwOavZji8HfHOU4hv6d9xp9pE_zf+g@mail.gmail.com>
Subject: Re: [PATCH 6.2 0512/1001] tty: serial: qcom-geni-serial: stop
 operations in progress at shutdown
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Srini Kandagatla <srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 Mar 2023 at 18:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>
> [ Upstream commit d8aca2f96813d51df574a811eda9a2cbed00f261 ]
>
> We don't stop transmissions in progress at shutdown. This is fine with
> FIFO SE mode but with DMA (support for which we'll introduce later) it
> causes trouble so fix it now.
>
> Fixes: e83766334f96 ("tty: serial: qcom_geni_serial: No need to stop tx/rx on UART shutdown")
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> Link: https://lore.kernel.org/r/20221229155030.418800-2-brgl@bgdev.pl
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/tty/serial/qcom_geni_serial.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
> index 57f04f8bf5043..851a5d2133aa2 100644
> --- a/drivers/tty/serial/qcom_geni_serial.c
> +++ b/drivers/tty/serial/qcom_geni_serial.c
> @@ -891,6 +891,8 @@ static int setup_fifos(struct qcom_geni_serial_port *port)
>  static void qcom_geni_serial_shutdown(struct uart_port *uport)
>  {
>         disable_irq(uport->irq);
> +       qcom_geni_serial_stop_tx(uport);
> +       qcom_geni_serial_stop_rx(uport);
>  }
>

Greg,

Please drop this patch from all stable branches as it has caused a
problem in current master and - once fixed - is only relevant for new
(DMA) code.

Bartosz
