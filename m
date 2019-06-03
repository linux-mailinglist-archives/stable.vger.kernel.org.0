Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43E6233B8A
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 00:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfFCWoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 18:44:19 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37449 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbfFCWoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 18:44:19 -0400
Received: by mail-pl1-f196.google.com with SMTP id bh12so1447226plb.4
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 15:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i1NrrxtRQzUfMSgO3hbvNTalzhN+3gxpJj1nFq+byy8=;
        b=Epu3x+qUCsvLnQYtceW20enzegJsKK3kHgm4J1DEMqAmOFJtjdVYgQNRjDWwcmgBoe
         Ag6YPBpG+Mhg1KNgS3g8ttaJm3pEvTbqIgszuY7XnM1WwRATYvXirkBOzaLp3XPviLz1
         4HuQuuk4n9FoxU3dmMrm6UvGTq6rWTxeLltyY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i1NrrxtRQzUfMSgO3hbvNTalzhN+3gxpJj1nFq+byy8=;
        b=GWkpOSppWFP0MvfowNRjMvS+5tQ1hb4YT5/sYdOH1z1+64gYZoCu6cQC7pJeU+SJk+
         D8OxjpitUKXU5wbTieIzgbV0T4Dos/+ndM0WtywZhE9VSORpPOLgXVncu0lTP+trY/kp
         WPx/mDr0fEfbkzvz0sz5nfRnSkOtgre6XNBW/kvaJT2FrTHZjBlSHaWkMwVcJ6XKaU83
         uc1OTZscZ00V3CNS5WRj6C4q5s2G1rdEQ8m57wZTVFrEGEgs4rX1B3e7QJcDfLkbCojh
         NobQTp85YksrufHyOs/dsgyjpZ/pO/AP/MAtJRwMTL6/PFlXHVhF/ulNndGb6AUPD0/J
         5VoA==
X-Gm-Message-State: APjAAAVEMyWe6j5vxeZf01ewlY9LxG/sMaTl3EDdII1SkjaNxWlVOdiC
        YXraOZ2d9Nkdp9e5JI6qjtn5Fw==
X-Google-Smtp-Source: APXvYqzlBKFdd0t7IQz0yNeea1dEgjJHaS/dE8d8qTD0lMaX5q7l9JDvouMoOEUSk+7Pb/8WQjrToQ==
X-Received: by 2002:a17:902:2862:: with SMTP id e89mr33265524plb.258.1559601858570;
        Mon, 03 Jun 2019 15:44:18 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id l1sm14398404pgi.91.2019.06.03.15.44.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 15:44:17 -0700 (PDT)
Date:   Mon, 3 Jun 2019 15:44:17 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-rockchip@lists.infradead.org,
        Stefan Wahren <stefan.wahren@i2se.com>, tfiga@chromium.org,
        groeck@chromium.org, Martin Schiller <ms@dev.tdt.de>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: dwc2: host: Fix wMaxPacketSize handling (fix webcam
 regression)
Message-ID: <20190603224417.GN40515@google.com>
References: <20190531200412.129429-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190531200412.129429-1-dianders@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 31, 2019 at 01:04:12PM -0700, Douglas Anderson wrote:
> In commit abb621844f6a ("usb: ch9: make usb_endpoint_maxp() return
> only packet size") the API to usb_endpoint_maxp() changed.  It used to
> just return wMaxPacketSize but after that commit it returned
> wMaxPacketSize with the high bits (the multiplier) masked off.  If you
> wanted to get the multiplier it was now up to your code to call the
> new usb_endpoint_maxp_mult() which was introduced in
> commit 541b6fe63023 ("usb: add helper to extract bits 12:11 of
> wMaxPacketSize").
> 
> Prior to the API change most host drivers were updated, but no update
> was made to dwc2.  Presumably it was assumed that dwc2 was too
> simplistic to use the multiplier and thus just didn't support a
> certain class of USB devices.  However, it turns out that dwc2 did use
> the multiplier and many devices using it were working quite nicely.
> That means that many USB devices have been broken since the API
> change.  One such device is a Logitech HD Pro Webcam C920.
> 
> Specifically, though dwc2 didn't directly call usb_endpoint_maxp(), it
> did call usb_maxpacket() which in turn called usb_endpoint_maxp().
> 
> Let's update dwc2 to work properly with the new API.
> 
> Fixes: abb621844f6a ("usb: ch9: make usb_endpoint_maxp() return only packet size")
> Cc: stable@vger.kernel.org
> Signed-off-by: Douglas Anderson <dianders@chromium.org>

I'm not really familiar with the dwc2 driver, but this looks
reasonable to me. FWIW:

Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
