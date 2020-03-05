Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4617C17A02A
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 07:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgCEGtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 01:49:23 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:39559 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgCEGtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 01:49:22 -0500
Received: by mail-wm1-f53.google.com with SMTP id j1so4426012wmi.4
        for <stable@vger.kernel.org>; Wed, 04 Mar 2020 22:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=mDCjRtqr6C43Fr5bXqncHuyXuvzE856EQkpZZzQ2yMw=;
        b=CCPNgupRtViUZLR4XV+NNWnY9AbXnU8eUiNDxCYbEzfFFYPSIUe/1Xnu7Zo7YRTK21
         eEK8b+bqba3nBUpUFqtsUiA5jWCaCA6JfbOdYQKn2T9RpsLu2S0ZcbGrI1VUQXQBALtI
         bfyWxCwFmlK+v8sfVB768cP7rylfVcCwxbkDJs1hTz9dLGboPQmbluHYZrpY9iy4mPgQ
         iltvVx0HbTQoE/JrkFwEiLco3FJz12rdaeQQPXGv/89D0plQtKOosG8eSc18EmqEgX8A
         5do24kpgrGEBuEoDwV9Nc1cBQUGrkklItQCzLxTOLB+qimsD2zNHh0SXFQh5Fkd+p48B
         CD7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=mDCjRtqr6C43Fr5bXqncHuyXuvzE856EQkpZZzQ2yMw=;
        b=rO021eshkj1LUPtZVsAfUCi0skJOTKhVr707wRusclCzrCCKShNGPfrobQwT+Nzsnp
         V7AdMoYsp/Zz/H21RuHEwsJVK28X2D75lLOy7RxwFukgouvs681c98djfc0P4Vqou4Sr
         ib2kRoLo43l/hmnzBEN5MGijarhLU6/mQBg14ngd/Z6sHF3iDh8AYuwXmPr3nNXsrKq/
         v3X4nTLdESCJNXyDf+3+zNdU8w9/XXzh7SWhGqaNjrGVK+u0L0cpwj0JebjSlDBCoZzx
         J5PibVQ/2ZXwLarVKoexU7k2O6kkEgSt/b0JTn+zGpV1bq8fR78+xQ1DUHYjcYReO2pi
         HlSg==
X-Gm-Message-State: ANhLgQ1EogQNcCZ5+jr84/aREoRNyLtO/3blLc2MzA3/WuVOyC83PPie
        fGYccrqFWSX/WflQm3RE3majy395crg=
X-Google-Smtp-Source: ADFU+vspsxGS0ewgdlCb8avZPVK4jWM5rFyrPbZKysY90139QSPQaVpkYvN+XMptNr8YJXtM8G+3Cw==
X-Received: by 2002:a1c:4681:: with SMTP id t123mr7816306wma.69.1583390960691;
        Wed, 04 Mar 2020 22:49:20 -0800 (PST)
Received: from [192.168.0.102] (84-33-64-1.dyn.eolo.it. [84.33.64.1])
        by smtp.gmail.com with ESMTPSA id f6sm7683669wmh.29.2020.03.04.22.49.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 22:49:20 -0800 (PST)
From:   Paolo Valente <paolo.valente@linaro.org>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: block, bfq: port of a series of fix commits to 5.4 and 5.5
Message-Id: <543B99A1-B872-4F06-9A0F-EFFB9CAD5E14@linaro.org>
Date:   Thu, 5 Mar 2020 07:49:29 +0100
Cc:     Chris Evich <cevich@redhat.com>
To:     stable@vger.kernel.org
X-Mailer: Apple Mail (2.3445.104.11)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
Fedora requested the following fix commits, currently available in
5.6-rc4, to be ported to 5.4 and 5.5 [1]:
db37a34c563b block, bfq: get a ref to a group when adding it to a =
service tree
4d8340d0d4d9 block, bfq: remove ifdefs from around gets/puts of bfq =
groups
33a16a980468 block, bfq: extend incomplete name of field on_st
ecedd3d7e199 block, bfq: get extra ref to prevent a queue from being =
freed during a group move
32c59e3a9a5a block, bfq: do not insert oom queue into position tree
f718b093277d block, bfq: do not plug I/O for bfq_queues with no proc =
refs

No change is needed for these commits to apply cleanly in 5.4 and 5.5.

Fedora asked for this porting because it will allow them to include
these commits in their kernels, and solve the crash that led me to the
making of the commits themselves [1].

This is the first time I submit something for stable branches, I hope
I did everything right (I'm following option 2 in [2]).

Thanks,
Paolo

[1] https://bugzilla.redhat.com/show_bug.cgi?id=3D1767539
[2] =
https://github.com/torvalds/linux/blob/master/Documentation/process/stable=
-kernel-rules.rst

