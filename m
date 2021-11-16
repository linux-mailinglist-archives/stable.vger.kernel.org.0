Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0591C452F79
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 11:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbhKPKuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 05:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbhKPKuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 05:50:32 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3FBC061570;
        Tue, 16 Nov 2021 02:47:35 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id q21so2411456vkn.2;
        Tue, 16 Nov 2021 02:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N0F3X87qqLjtSlIy5Oj7v9TIEoZnHN4xn+PiZgIR73k=;
        b=jyH5OwR//ESuY2WLwA/4wBB0tyu7nEDnnHPVwrFCbCe43HQ1QZsoYn3INpMckM5POq
         0jkt7nFioOFrFi1x+L/hZydsP/aeuPv+QmJ/MEGNXuFNfdNFqoVkPkpBHT32fAROWp2z
         4uDATRKRfFFHHCRW6kzOs/hwjrNKSp3cA7ESTMrXcW5Yv9BrrUN2Hy3IXGmASDhrqXTQ
         QmvA2xj0FYq1Js4JykfqNUgfCazweVVeVvI2Bd/VDWLuDZRb0/F06sgSWIWShjZB2cxS
         YnaFgfoP6pH/ai5Y7MyFkdpHexa78W07HvutVMsuSZViwvsk8QvXdt8lDBYZqGNZSorg
         95MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N0F3X87qqLjtSlIy5Oj7v9TIEoZnHN4xn+PiZgIR73k=;
        b=6E29HH3X1H1K244SZxtFHFNCejZe0BR/foqj+yY6GxU0OhomUjMdUKxnG5bh/7dorH
         Nln1QnD+vUXRWZ8bSL1tloGTbnN8ylIOtU1hWSxg/ln/pYB5/ijScWn4PrbXmPKttS/Z
         McBBmed7AYWnl27s6UGc5sYuoegmkAZfQaEJuA+ZL/DoHuODbVRFfWCEHc6Lc3meIOiu
         GVvy0KWJ9GwR+OgV4Z9rCdldPC1viEbJOeoLU6NFRUIcdcq63DmEUMbn2k0cuIWFJQaY
         +E0mQsV/TJ2Doh7LLtoz7m5XGdJduw5fX1hCqsHMv19e+6i3a4ouWUt8zNPvu4BIek4D
         HTNg==
X-Gm-Message-State: AOAM5334lH2+kscxKZ1mWsqkVNWpH5HWFJnEZ6sAlAPh8e8uI6tVnOpN
        ukfc4axIfA2IDlsTNoJlN7k1B8s0CUoD5r3ieQ==
X-Google-Smtp-Source: ABdhPJxsR3E2mWHsYyQx7VDQmEj5mWtqN51EqLPWP8YZTg8kiealzynpu3tvt4pN3gPZa7DEDLk1kaRdJLTeZD3WkZQ=
X-Received: by 2002:a05:6122:214e:: with SMTP id m14mr48370785vkd.19.1637059654211;
 Tue, 16 Nov 2021 02:47:34 -0800 (PST)
MIME-Version: 1.0
References: <20211104180130.3825416-1-maz@kernel.org> <87ilx64ued.ffs@tglx>
 <CALjTZvag6ex6bhAgJ_rJOfai8GgZQfWesdV=FiMrwEaXhVVVeQ@mail.gmail.com> <YZOKV6z+6pDjjvcl@kroah.com>
In-Reply-To: <YZOKV6z+6pDjjvcl@kroah.com>
From:   Rui Salvaterra <rsalvaterra@gmail.com>
Date:   Tue, 16 Nov 2021 10:47:23 +0000
Message-ID: <CALjTZvaeujHJw-EV1Y=+npjXzYFiiQ9sbu6tE6do63F9R4dRqg@mail.gmail.com>
Subject: Re: [PATCH 0/2] PCI: MSI: Deal with devices lying about their masking capability
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        kernel-team@android.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Greg,

On Tue, 16 Nov 2021 at 10:39, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> What is the git commit ids of these changes in Linus's tree?

2226667a145d ("PCI/MSI: Deal with devices lying about their MSI mask
capability")
f21082fb20db ("PCI: Add MSI masking quirk for Nvidia ION AHCI")

Thanks,
Rui
