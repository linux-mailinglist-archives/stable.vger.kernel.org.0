Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A169616F2C4
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 23:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgBYWwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 17:52:43 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:37225 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729271AbgBYWwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 17:52:39 -0500
Received: by mail-vs1-f65.google.com with SMTP id x18so582202vsq.4
        for <stable@vger.kernel.org>; Tue, 25 Feb 2020 14:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/7MQONwXqnHZRXQDO+5cFHOizIPUenx2kjrngECUQSQ=;
        b=ML4KwGNSQIrO0D7ruk1fYSg4pB4VLASqOhJQ3+uvt30zctxClfPEpcN/raNLCNmle0
         SzlFwyCZJpsknAC2v7Mx6mWCveGnkD2zRjQq6VBxAdF6c4ozhJ2E419eCZdmA/VTqlB5
         gtjdkt9Xhdv+Hl8JBcTplN/eAA3umRtDZL0Ks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/7MQONwXqnHZRXQDO+5cFHOizIPUenx2kjrngECUQSQ=;
        b=o0ghJTH7cnjXbxvThQyp96tgVFtpbYuRpFm25yYm1hMQV/I3Q0rqwTJbcRM02fpLck
         A3r0V3J93xWEIRHQodXG5OK+hAKW+7fpvCY4yy+cMb7sDkSiiSu5g0wSIVWYKO4sabpl
         0Yk4LNrAKRXnjf2F1X64rb1nuijQUwNqaxLanVNPahhu4a1HU7z73AsIoqmY8ngzmj0j
         FTZDMx9BxO551d4z+w6+PMneWP9S45PhJ/IeW0CKgXCaoP4L84f2n2jxpQZP0XGLrVVT
         4RoEQ8Mn97/3jgXStNbNjbYWzDVjd952DMSidTT4fqNWN+fVsCpphEfWc9uYmb818dEp
         TN8g==
X-Gm-Message-State: APjAAAXlq0szdUoKxU0NW7C7A54JstuyoCUcW2+a7PhhQqYtcgnIA2Ry
        F/Rg/9BnaP4vCqXp7PtmoQ72qZ1x+3g=
X-Google-Smtp-Source: APXvYqwB4S8x3T68PcsBX23PmOSr7vJmOE1lAFNrdlJCrdTOXuPjmdya7WaypMH5qxmMi2znsLqfOw==
X-Received: by 2002:a05:6102:677:: with SMTP id z23mr1419686vsf.202.1582671157901;
        Tue, 25 Feb 2020 14:52:37 -0800 (PST)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com. [209.85.217.51])
        by smtp.gmail.com with ESMTPSA id r190sm95731vkf.43.2020.02.25.14.52.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 14:52:36 -0800 (PST)
Received: by mail-vs1-f51.google.com with SMTP id 7so552042vsr.10
        for <stable@vger.kernel.org>; Tue, 25 Feb 2020 14:52:36 -0800 (PST)
X-Received: by 2002:a67:e342:: with SMTP id s2mr1474052vsm.198.1582671156402;
 Tue, 25 Feb 2020 14:52:36 -0800 (PST)
MIME-Version: 1.0
References: <20200103045016.12459-1-wgong@codeaurora.org> <20200105.144704.221506192255563950.davem@davemloft.net>
In-Reply-To: <20200105.144704.221506192255563950.davem@davemloft.net>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 25 Feb 2020 14:52:24 -0800
X-Gmail-Original-Message-ID: <CAD=FV=WiceRwLUS1sdL_W=ELKYZ9zKE13e8vx9SO0+tRvX74QQ@mail.gmail.com>
Message-ID: <CAD=FV=WiceRwLUS1sdL_W=ELKYZ9zKE13e8vx9SO0+tRvX74QQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Wen Gong <wgong@codeaurora.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, ath11k@lists.infradead.org,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,


On Sun, Jan 5, 2020 at 2:47 PM David Miller <davem@davemloft.net> wrote:
>
> From: Wen Gong <wgong@codeaurora.org>
> Date: Fri,  3 Jan 2020 12:50:16 +0800
>
> > The len used for skb_put_padto is wrong, it need to add len of hdr.
>
> Thanks, applied.

I noticed this patch is in mainline now as:

ce57785bf91b net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue

Though I'm not an expert on the code, it feels like a stable candidate
unless someone objects.

-Doug
