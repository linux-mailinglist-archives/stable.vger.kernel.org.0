Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7893EB804
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 20:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfJaTg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 15:36:57 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:42664 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbfJaTg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Oct 2019 15:36:57 -0400
Received: by mail-il1-f194.google.com with SMTP id o16so6466975ilq.9;
        Thu, 31 Oct 2019 12:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8hKiZ0BGQD5nx5BySHMaCs45A5ymyfaXhrQ8avV6SgE=;
        b=QASbPTpQ1UN0fSYhWrwvLsDfPcrd17dZWg6iePOP0jlDVLqseQmO3Vi60YBpfBHMgZ
         /gYrtXo4l0wYUwWQA8A20rqPAyyXKQ9SoKwgCcYcCzyARJgY/L1E/DYPFGzhCdyuwDtG
         tGkGXP5ejLlBJua0Kt1W+FqaBaMgW2nKmOkyTHSjIO5e6MHnTI3SwAY3kRJ5VUVaGjhU
         LLGqPxxJFY+vZU8BtHlAq5zum1HCeloe40L0iMcMyplMJwLHnZbBHcCfyyWLaIQ6jY9T
         HZj4mm1xBgCnyRVnHcbEVCNYmF9RkbRRUEThrJbDnhfPm9Bnm29E+f5u1Dqsl7IRKZyc
         8VDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8hKiZ0BGQD5nx5BySHMaCs45A5ymyfaXhrQ8avV6SgE=;
        b=o0LqQ7g4aPuCWY3Yv6dtwjfznQ/hj4LUjtgElk13+hB1CseLQAiEhmfjALJAh6v2n3
         b/z+Ivj5iaXdwVG0FrRnicknUkbzamH5guV+LNoQ+rPNAer6oa4gslGl6u+cP+lmzj+1
         3RlhVGo652MKkXp1qOafAp71QK+Ma7rjDGJBdIXfpVyL4ORAfJAN2R4JfAHbu5UEoPU8
         6dUKTLlrU8EC+oDY1MiWxwm+RMwnxNdcFWs0hCPiN9qj9xBoT0wYtgroWylLnLxsYhiz
         mzt+XhaxCVkAddXvTa1cnxQvtzIjAfUEGaHYC/9b/tgKqk1DNVpkwifmQBq9LRtBXnQu
         tbhA==
X-Gm-Message-State: APjAAAXpHHAdNL0k/PfWGF7YF+tBHO5pnEKze0pZalEbwsNcB73awdjx
        lhXu70gSH6fNZZn8y4meVu+o/bmLavjBe/1BBdI=
X-Google-Smtp-Source: APXvYqx2VJtS/SdW21beW5VwH9Lu+WwCGYimDaoxk9YrwjUbTAo501haM6105RK1xvP88EE1CDQyVkFFxg7L0k2aSLs=
X-Received: by 2002:a92:1d51:: with SMTP id d78mr8479316ild.166.1572550616674;
 Thu, 31 Oct 2019 12:36:56 -0700 (PDT)
MIME-Version: 1.0
References: <20191031184632.2938295-1-bjorn.andersson@linaro.org> <20191031184632.2938295-2-bjorn.andersson@linaro.org>
In-Reply-To: <20191031184632.2938295-2-bjorn.andersson@linaro.org>
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Date:   Thu, 31 Oct 2019 13:36:45 -0600
Message-ID: <CAOCk7Noq8dvKsWzAfAXRGhmoMG4_tHD0kw8_KVEBvyjm_fGc5A@mail.gmail.com>
Subject: Re: [PATCH 1/2] remoteproc: qcom_q6v5_mss: Don't reassign mpss region
 on shutdown
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Ohad Ben-Cohen <ohad@wizery.com>,
        Avaneesh Kumar Dwivedi <akdwived@codeaurora.org>,
        MSM <linux-arm-msm@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Sibi Sankar <sibis@codeaurora.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 31, 2019 at 12:48 PM Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
>
> Trying to reclaim mpss memory while the mba is not running causes the
> system to crash on devices with security fuses blown, so leave it
> assigned to the remote on shutdown and recover it on a subsequent boot.
>
> Fixes: 6c5a9dc2481b ("remoteproc: qcom: Make secure world call for mem ownership switch")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---

Excellent.  This addresses the issue I was seeing with the Lenovo Miix 630

Reviewed-by: Jeffrey Hugo<jeffrey.l.hugo@gmail.com>
Tested-by: Jeffrey Hugo<jeffrey.l.hugo@gmail.com>
