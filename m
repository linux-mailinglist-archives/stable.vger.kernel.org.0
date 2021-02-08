Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93422314179
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 22:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235248AbhBHVQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 16:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbhBHVPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 16:15:38 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BC5C061786
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 13:14:57 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id j21so422010wmj.0
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 13:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=7qwTJ3jO82X57nS5JyvSj2W0n38yGschlE6VIh0eevU=;
        b=HDYM1lMAjUTfMuUGms4FcsyhBqYyVc++Srvp1OJ56hYpb9BQPasyckIXvm6bLzh+Ft
         m6Low80b8m53t67mg/+BU20A9FVYM6nYZkDssn8EcYKfqmVUJt3d8vPEit9J65dSpp4N
         AA+SRvXFEe7qkraVbiSaJNi3xKi76WVTDPsSN8eDMKcZ/jzF6GYeVp4/qYegfHOTMRMj
         N33Kz0SjzN0A4+ne/cqgn0wdyva3TqF9856SRNHHh5kkhqwOl5KEcBeFLvvjKIUvVcKs
         w5F6lHefpuQS4QUxCWSVZ1AmFAnmPeSXCJV74wUddPm0+4dpDiHys9ysZixPogiXAsbX
         De2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=7qwTJ3jO82X57nS5JyvSj2W0n38yGschlE6VIh0eevU=;
        b=fj8kcjz7b/Wd7Qcm5WU+9aiaVi7zUnVAtaUS0tvtAQkkFnziEgJl2eDqdjsYSKPcEX
         Xn1cPYzME/KyULKEH+UbAuobYl+ySS7IQvvt6kuxKMj3sNV9CbHsiG2+Ya7kwp2MmbSn
         g9Tl7u03w7/afZauHj2MsA9j8j/m8wNse/uChetsfapSMDzjDxBl+oYo2sU3X/sQbEO0
         WdjstQbzADvi8b0s7sYhMgdzLNV8mwn1NJ4+95bbTEtkGYW81/LMqzscQXFkKYOgvysl
         zXFicHmvmqjtGmnOpLsyNkrxnRju3rKRDAGtKjHDWLcD7F6QHdjnGUA8yX3+sG97AioG
         ZWzw==
X-Gm-Message-State: AOAM530OE7f7uzML7BhGnHreBfKJsFZdcfUiPDGxnu6rzUJ72tVVP9QF
        J8RV0EVR8LKyjYWkBg97eOiqRSdS+GeFOwL75tqzocFvErc=
X-Google-Smtp-Source: ABdhPJxUmzgW9p1ZmbnKw0LIHhF4M2QFAaPtFc5sIEiiVRgwVR7+tZrJit9ExV5mqOPwZ3yEuGiX3ROaglS+QwUGe+Q=
X-Received: by 2002:a05:600c:48a8:: with SMTP id j40mr553048wmp.57.1612818896282;
 Mon, 08 Feb 2021 13:14:56 -0800 (PST)
MIME-Version: 1.0
From:   David Michael <fedora.dm0@gmail.com>
Date:   Mon, 8 Feb 2021 16:14:44 -0500
Message-ID: <CAEvUa7mYi9J6qUbnUJi9=_+AXeXOopYJkZb+Z4CD9enGEQaFBQ@mail.gmail.com>
Subject: Reporting stable build failure from commit bca9ca
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Commit bca9ca[0] causes a build failure while building for a G4 system
since 5.10.8:

arch/powerpc/kernel/head_book3s_32.S: Assembler messages:
arch/powerpc/kernel/head_book3s_32.S:296: Error: attempt to move .org backwards
make[2]: *** [scripts/Makefile.build:360:
arch/powerpc/kernel/head_book3s_32.o] Error 1

Reverting the commit allows it to build.  I've uploaded the config[1],
but let me know if you need other information.

Thanks.

David

[0] https://github.com/gregkh/linux/commit/bca9ca5a603f6c5586a7dfd35e06abe6d5fcd559
[1] https://dpaste.com/7SZMWCU89.txt
