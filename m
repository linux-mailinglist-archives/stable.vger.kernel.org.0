Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54CFB15FA9
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 10:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfEGIop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 04:44:45 -0400
Received: from mo-csw1515.securemx.jp ([210.130.202.154]:52174 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfEGIop (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 04:44:45 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id x478iZX5032021; Tue, 7 May 2019 17:44:35 +0900
X-Iguazu-Qid: 34trdEsBYeq0nk84MX
X-Iguazu-QSIG: v=2; s=0; t=1557218675; q=34trdEsBYeq0nk84MX; m=v4RU/QN3+eLWzfyeYzcWxU1KH8L8IUhV6/7htfKnXoQ=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1511) id x478iY1r031159;
        Tue, 7 May 2019 17:44:35 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id x478iYUR008098;
        Tue, 7 May 2019 17:44:34 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id x478iYkv030958;
        Tue, 7 May 2019 17:44:34 +0900
Date:   Tue, 7 May 2019 17:44:30 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 4.19 79/99] ASoC: wm_adsp: Correct handling of
 compressed streams that restart
X-TSB-HOP: ON
Message-ID: <20190507174430.2e981704@fdyp522>
In-Reply-To: <20190506143101.240836871@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
        <20190506143101.240836871@linuxfoundation.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, May 06, 2019 at 04:32:52PM +0200, Greg Kroah-Hartman wrote:
> From: Charles Keepax <ckeepax@opensource.cirrus.com>
>
> commit 639e5eb3c7d67e407f2a71fccd95323751398f6f upstream.
>
> Previously support was added to allow streams to be stopped and
> started again without the DSP being power cycled and this was done
> by clearing the buffer state in trigger start. Another supported
> use-case is using the DSP for a trigger event then opening the
> compressed stream later to receive the audio, unfortunately clearing
> the buffer state in trigger start destroys the data received
> from such a trigger. Correct this issue by moving the call to
> wm_adsp_buffer_clear to be in trigger stop instead.
>
> Fixes: 61fc060c40e6 ("ASoC: wm_adsp: Support streams which can start/stop with DSP active")
> Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This commit has other problems, and it is fixed by commit 43d147be5738a9ed6cfb25c285ac50d6dd5793be.
Please apply this commit too.

commit 43d147be5738a9ed6cfb25c285ac50d6dd5793be
Author: Charles Keepax <ckeepax@opensource.cirrus.com>
Date:   Tue Apr 2 13:49:14 2019 +0100

    ASoC: wm_adsp: Check for buffer in trigger stop

    Trigger stop can be called in situations where trigger start failed
    and as such it can't be assumed the buffer is already attached to
    the compressed stream or a NULL pointer may be dereferenced.

    Fixes: 639e5eb3c7d6 ("ASoC: wm_adsp: Correct handling of compressed streams that restart")
    Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
    Signed-off-by: Mark Brown <broonie@kernel.org>

Best regards,
  Nobuhiro
