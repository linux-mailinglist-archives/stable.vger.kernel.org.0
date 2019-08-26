Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5BA69D4CF
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 19:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbfHZRQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 13:16:11 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35216 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729128AbfHZRQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 13:16:10 -0400
Received: by mail-pf1-f196.google.com with SMTP id d85so12221385pfd.2
        for <stable@vger.kernel.org>; Mon, 26 Aug 2019 10:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=upMtoPcQAviyPNZIacJCDQAUJ2i1cRV46pJVfRcWYNo=;
        b=lYTUGiHNoFuE3MNPjaJuPELNuKE3gSnC2Ca1mtK7vU7gVEa/LWM1oJI4EOm2eD6yy0
         f+Vkk7DcTCfwYoSNMpIV8E2C6ooQFQXOkfIEZlUrEE2e0suCCKk8jYX7RXTzA9tuxdLf
         MUlphQw/xdqQxW2lHCFmXar9p6qpVZYoDFzJ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=upMtoPcQAviyPNZIacJCDQAUJ2i1cRV46pJVfRcWYNo=;
        b=R1qgHKU5Hcms4KutrFtYpvMBag8WLG489kc0paFENqH2We0Y94FQWMj4cOS6Z/Xpq8
         wibUIM3zZ/eM2yhMlmfdLM5OSU83+xi6VSJ84EUMm2S1qL699KrDwnEFuMief9gBO6si
         jmf9BlCGMD7o7fcISYK2NN+5dI6HuZBtwgTS2rzQa6Ze/47oXSvKRchi7yQtKtbfBRBm
         RNmVt54QRfPhbm5ChbEzy+GOa9DyUwdu9EzMsv0cbZEnMUuNLMp1t2AJdQfZe7LqWWtT
         +sAwoGwV1KP/2Zw4gdYqpnqXvluwSekctCpUXAI3E3dKKCk/9rw9TKhKKQ8NSDdUcfyq
         IS4w==
X-Gm-Message-State: APjAAAWyCe0RP32LhadZXLcA6CMS2mlHOpkSm4Jw9HNKk2whw4S8nppY
        1nTOHMejy6UnnOBHfo94a4O4Ow==
X-Google-Smtp-Source: APXvYqxcRzqAHV69rruJOGyiziSlxdHAjT1l1knKHpci3t4HuPwyzVOQipAbguTBq66zKm9VVtIEQQ==
X-Received: by 2002:aa7:8007:: with SMTP id j7mr21170373pfi.154.1566839769982;
        Mon, 26 Aug 2019 10:16:09 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id q3sm17085866pfn.4.2019.08.26.10.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 10:16:09 -0700 (PDT)
Date:   Mon, 26 Aug 2019 10:16:00 -0700
From:   Zubin Mithra <zsm@chromium.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        groeck@chromium.org, bristot@redhat.com, tj@kernel.org,
        lizefan@huawei.com, hannes@cmpxchg.org, juri.lelli@arm.com,
        rostedt@goodmis.org
Subject: Re: [PATCH 4.4.y] cgroup: Disable IRQs while holding css_set_lock
Message-ID: <20190826171558.GA232744@google.com>
References: <20190823174421.81149-1-zsm@chromium.org>
 <20190826011856.GD5281@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826011856.GD5281@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 25, 2019 at 09:18:56PM -0400, Sasha Levin wrote:
> On Fri, Aug 23, 2019 at 10:44:21AM -0700, Zubin Mithra wrote:
> > @@ -2149,7 +2155,6 @@ out_free:
> > 
> > 	if (ret)
> > 		return ERR_PTR(ret);
> > -
> 
> Where did this come from?

This probably came from doing a git format-patch on a different kernel;
recreating the patch on top of stable@ i see that this does not show up. I'll
resend this.

Thanks,
- Zubin
