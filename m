Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61EC89A133
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 22:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389606AbfHVUdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 16:33:01 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:43516 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389188AbfHVUdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 16:33:01 -0400
Received: by mail-lj1-f182.google.com with SMTP id h15so6772151ljg.10
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 13:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aSnnc8KBnx7nrvm7nH0Gg3VFjqjZe9P0okjTldYJjjI=;
        b=iSYgPMbsL3t6QnFwApaGXlR0ZbuJs+IAPKIsNUEqxemsMpgbcVe6mSUpMDalbU/ynk
         SImZR6mf+Pp+jqfXBRZXecFPsJaR+boZwmg96r7FAbVkf7NIqcBXWfAbX4qtWr2PhJgp
         d12vXFDVjMQ02Zr5ssJiB1GXnyGDqa8HoXJVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aSnnc8KBnx7nrvm7nH0Gg3VFjqjZe9P0okjTldYJjjI=;
        b=ezlZ8yo1+BTur03G2OQjYRePTrQR/8ptZPXaSQk+zLN1E61boXpNQMTCdaXM/3ubvZ
         bdniwDXA0vwuVV+XWZPTF6fPqTZoKH4Jee+VEhc48lvbNvT0y9HX73jjEsx6EiN7CTMp
         CZ9TmHlPAV+S83EDfPUJcuNlwiL2Xc07lMLO+C+FQMQsLExM44EwSXFijzncj/UAotLw
         9JpyNr1y+t/ZjYYii/Gcks/kMlr7Zbf+yZRoGWWDvfLWU7d2rknuLXBuwrN5PX/b8P0i
         ZAcmukjBFrw8CljeFmQecuXcVqzaSSyOl4Kqst40hgfCeyXdtBH9CKl+74DL5ID0lELo
         lfiQ==
X-Gm-Message-State: APjAAAVTPqvAa+P51ZmROkppDJokhgxCOk3vH/cQhFeaucLnR6AeGjHR
        i7U2icEWDUlzJhSfAtgcqnPaDKh5jcI=
X-Google-Smtp-Source: APXvYqzonazF5YP8UblpMNxfC86/uGh3nhm9JpWK8Mp9Yp5gBXB78nVi3N817ncwPHzqHkmhjVdkQg==
X-Received: by 2002:a2e:3004:: with SMTP id w4mr703244ljw.216.1566505978933;
        Thu, 22 Aug 2019 13:32:58 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id b27sm171060ljb.11.2019.08.22.13.32.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2019 13:32:57 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id 62so5467806lfa.8
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 13:32:57 -0700 (PDT)
X-Received: by 2002:ac2:5181:: with SMTP id u1mr561108lfi.42.1566505977561;
 Thu, 22 Aug 2019 13:32:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190816075842.27333-1-committed@heine.so> <20190822014655.GA165945@google.com>
 <5D5E47B1.70604@heine.so>
In-Reply-To: <5D5E47B1.70604@heine.so>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 22 Aug 2019 13:32:46 -0700
X-Gmail-Original-Message-ID: <CA+ASDXMETzc72iZq5pN6QfySXGiHQEcsB0A5ZujSyg-YhKNBBw@mail.gmail.com>
Message-ID: <CA+ASDXMETzc72iZq5pN6QfySXGiHQEcsB0A5ZujSyg-YhKNBBw@mail.gmail.com>
Subject: Re: [PATCH] power: supply: sbs-battery: only return health when
 battery present
To:     Michael Nosthoff <committed@heine.so>
Cc:     linux-pm <linux-pm@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 22, 2019 at 12:43 AM Michael Nosthoff <committed@heine.so> wrote:
> This done at the end of 'sbs_get_property' if the presence state changed and
> no gpio is used. I suspect it triggers a readout of all the properties
> and leads to this
> endless loop?

Ah, it's not all properties IIUC, but it does lead to
power_supply_update_leds() -> power_supply_update_bat_leds() ->
power_supply_get_property(... POWER_SUPPLY_PROP_STATUS ...). That
would be enough to kick off the loop you're noticing.

Brian
