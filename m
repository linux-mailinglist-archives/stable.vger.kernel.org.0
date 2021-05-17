Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0BDB3836A4
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241488AbhEQPfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244134AbhEQPc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 11:32:27 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4A5C06137D;
        Mon, 17 May 2021 07:32:49 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id 5so3204144qvk.0;
        Mon, 17 May 2021 07:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=THOJoa9goNNyDVOh5QQdcefIk4gsILRnxGGzLYO5As0=;
        b=Zs0nZPfdCFHS+jiRnL+KUKTc1A3XyZH58TySt1g06gNB+Z8z+RQMXwETfnsv2Zf7MY
         3kru/VHbJogwd4dgUQ4N2IG+bi5jwr+BlNm9hFwCR7dt5G+1Lcw2zlkIhClDJOsmmlCU
         7wEAzOWBaeu7sgDkNspAV70oTaMYDdVF85TgWzDBAci2Yurn+zRsVdEFWZlpITk1wMfk
         NpD8s17hlMPbTlx7stJeX4xCtxk5nCwq1YpGvt0Mck2UKAlvlQWktqnG1MjY2EgARQbR
         Ls+/4PPI1aaI6un/2+xMpUgspbkF1aZaGiq0+4d8QBxZhbP8Wcb3KMIk/kdRm/wISDtU
         pxDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=THOJoa9goNNyDVOh5QQdcefIk4gsILRnxGGzLYO5As0=;
        b=ndWwQplz1Ik+EF8F+UFYvlGVi+b/fADRsqCzNdSgmvRV39DjBZwqfZPQyTZf8E97hL
         UqrrLYT9i0iuf6cUv6Cw7t4opNXibHaqB0Ogoxkl+3ZyCjRxMOd5V87WNHeHqK0XPpYm
         C3UAYw5OPFRxD/bU8FPVtAysXvEJhguN1nU2zPcCV0h0x/D54PjvpYt9GRKIrRs9hsiE
         YTf2taVhtbYkHY2uaGxCE36JztgQhbX6VBRGCFUf4TY0pXXycq+p+H63AKMeu98VI+WO
         naGaP7vbuuqf27oOa/K1F3p2NttmS2wYSuSyw6ghuAW4ge2WQ4es76yq0cu9N2DTsNij
         yMNA==
X-Gm-Message-State: AOAM530s3HSsNHWHiSfzNRLQcpCxWS89cvlmC+x2MWi3DNPfJWeiN9iY
        PDhVvAP6BohK7N/0W/s6QBw=
X-Google-Smtp-Source: ABdhPJytu85FbMC7Pk4Simc+JUTdrO+Fyj4LkQ2v0YbWXKANmhpN7uT81xvH+P54zhFwBZA9nuJDlQ==
X-Received: by 2002:a05:6214:a43:: with SMTP id ee3mr170152qvb.61.1621261968638;
        Mon, 17 May 2021 07:32:48 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 25sm500001qtd.51.2021.05.17.07.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 07:32:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 17 May 2021 07:32:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/4] usb: typec: tcpm: Fix up PR_SWAP when vsafe0v is
 signalled
Message-ID: <20210517143246.GA3434992@roeck-us.net>
References: <20210515052613.3261340-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210515052613.3261340-1-badhri@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 14, 2021 at 10:26:10PM -0700, Badhri Jagan Sridharan wrote:
> During PR_SWAP, When TCPM is in PR_SWAP_SNK_SRC_SINK_OFF, vbus is
> expected to reach VSAFE0V when source turns of vbus. Do not move

s/of/off/ as already reported

> to SNK_UNATTACHED state when this happens.
> 
> Fixes: 28b43d3d746b ("usb: typec: tcpm: Introduce vsafe0v for vbus")
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>

Otherwise

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/usb/typec/tcpm/tcpm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index c4fdc00a3bc8..b93c4c8d7b15 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -5114,6 +5114,9 @@ static void _tcpm_pd_vbus_vsafe0v(struct tcpm_port *port)
>  				tcpm_set_state(port, SNK_UNATTACHED, 0);
>  		}
>  		break;
> +	case PR_SWAP_SNK_SRC_SINK_OFF:
> +		/* Do nothing, vsafe0v is expected during transition */
> +		break;
>  	default:
>  		if (port->pwr_role == TYPEC_SINK && port->auto_vbus_discharge_enabled)
>  			tcpm_set_state(port, SNK_UNATTACHED, 0);
> -- 
> 2.31.1.751.gd2f1c929bd-goog
> 
