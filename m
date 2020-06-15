Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448591F8E83
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 08:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgFOGuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 02:50:06 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46555 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728486AbgFOGuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 02:50:05 -0400
Received: by mail-ed1-f67.google.com with SMTP id m21so10634074eds.13;
        Sun, 14 Jun 2020 23:50:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vKJpOmM9DH/2UhmBwmYAEHUF6KlZyjtAnBjFXv+lhg8=;
        b=dmMil4HxQdMjiwap0oj02lDOttOFmdYfxNdo6qimXZEJey9PaW4lt7dchzUKNZnNm+
         z7mwgequY2fF4TjR7H2qFZ9i+DAnwm9ZNf8JsTq0rkLJlx5C9r/F5mHA84fm0K9uvp4Z
         QR5GzFU7Nw6DL9Y1P/u9oNz4pHRzEnPdICuO+Y2/Zx3LDejSbrmDw6h9IQAeggeSf7Xo
         mtyu0FSpwJ1C8AIFyFA+mfNkOj4yEZC9DzYvqBF1pfUpEQhjH9aucjbxM/b8W6cZTIU2
         dun0FIbro9YNICwlnKzNb6/A7/hkDP+0W3nNVp0HNligaZKrxijhIq/vOavAHlo5DHlb
         e/1A==
X-Gm-Message-State: AOAM531A240ThJkVfk3YXzN+m+IJ6UCL+iSVgoU5Ih1vEWbwVsGYYBjg
        J26T67fqZ5C536bed+1FEyI=
X-Google-Smtp-Source: ABdhPJxD5/50BDSpXBl1ldUdAkvys7Ip8mS9MB2im+cSgFQh8Vj0lNC/SZV7F9XvmjbinVMlk37bfQ==
X-Received: by 2002:aa7:d388:: with SMTP id x8mr23084385edq.380.1592203803200;
        Sun, 14 Jun 2020 23:50:03 -0700 (PDT)
Received: from kozik-lap ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id q14sm7801859edj.47.2020.06.14.23.50.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 14 Jun 2020 23:50:02 -0700 (PDT)
Date:   Mon, 15 Jun 2020 08:50:00 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] i2c: imx: Fix PM runtime inbalance in probe error
 path
Message-ID: <20200615065000.GA7728@kozik-lap>
References: <1592130544-19759-1-git-send-email-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1592130544-19759-1-git-send-email-krzk@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 14, 2020 at 12:29:03PM +0200, Krzysztof Kozlowski wrote:
> When pm_runtime_get_sync() fails in probe(), the error path should not
> call pm_runtime_put_noidle().  This would lead to inbalance in
> usage_count.
> 
> Fixes: 588eb93ea49f ("i2c: imx: add runtime pm support to improve the performance")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> 
> ---
> 
> Changes since v1:
> 1. New patch

This patch is not correct because the runtime usage counter is increased
always, also on failures.

It can be dropped.

Best regards,
Krzysztof
