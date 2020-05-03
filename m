Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070E81C2FD6
	for <lists+stable@lfdr.de>; Sun,  3 May 2020 23:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgECVtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 May 2020 17:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729143AbgECVtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 May 2020 17:49:23 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A26C061A0E
        for <stable@vger.kernel.org>; Sun,  3 May 2020 14:49:23 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id b20so7773729lff.2
        for <stable@vger.kernel.org>; Sun, 03 May 2020 14:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=3lkwUf97KrZvf5X62QsC+U/twsMrl7EX6SopeNpG08w=;
        b=AL+TxTKigDJJbsWCxYYa0++46F8ifL1gWEOsuBb5V0R/Xfn8HJGfQA6TzCP0bdzoue
         IgW0hwgnth0+18sRXYLrdsvFr84QINV7O2sghzVXBLI5/vFMb61tqrAsveNSYesfgXkS
         g58w44K+W3DqWMKI8NJ/vZ6zP/1mwbliJyhyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=3lkwUf97KrZvf5X62QsC+U/twsMrl7EX6SopeNpG08w=;
        b=Tamsvo1Y1mZqbqpsLB/kiT/jB9xEA8oy9kA0g/8hEz0moE5Th2Y9k2o89Em+WtcpjL
         Eur4iUKfp61+AZL8uvSYl0V88WD+w+8JrrxqM3A+F638y5ExkWOIonPrmdXpXrFzTvrY
         G40IQRZ8DtZd+BAJ4G+trB6KsrXoigAHVa7+szG2n9uyADbO3sLwprQuq4DhUTLbtENu
         +m3w59fTUQ+jQZF6nRrCuC/cLQFtnv8tK31WC/J2Ccz4W6OX5i3z5C5YlC4h4tgjxJJf
         RdQU7LXlJ0vVIcVmGS6gktbIOKWzgPSZrNQKlZuLNZrHN0CxWEDMQY/JvajrY8axNHTY
         PhRg==
X-Gm-Message-State: AGi0PuZt1bl4cBBJkX8w2px2YAcPmgqDbZaImgJw+9LPFKX8NiBsU9F/
        30XaJnkBjmwP79eu9cmo+hOyuijc1T8=
X-Google-Smtp-Source: APiQypKtVbCmPd2azqGYRIxr1XsL/xD/kp31ohDPWeNcDopEDsvpYS/ay4PGO71oUXthWnhb+zd2tw==
X-Received: by 2002:a05:6512:2027:: with SMTP id s7mr4243400lfs.39.1588542561329;
        Sun, 03 May 2020 14:49:21 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id u12sm6552022ljo.102.2020.05.03.14.49.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2020 14:49:20 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id g4so7816606ljl.2
        for <stable@vger.kernel.org>; Sun, 03 May 2020 14:49:20 -0700 (PDT)
X-Received: by 2002:a2e:814e:: with SMTP id t14mr8364410ljg.204.1588542560282;
 Sun, 03 May 2020 14:49:20 -0700 (PDT)
MIME-Version: 1.0
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 3 May 2020 14:49:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi6dw+Hu95GvcF=vdFbAp+H4NUWkUxG0N9VFRJBU0Xv=Q@mail.gmail.com>
Message-ID: <CAHk-=wi6dw+Hu95GvcF=vdFbAp+H4NUWkUxG0N9VFRJBU0Xv=Q@mail.gmail.com>
Subject: DRM broke for AMDGPU in 5.6.10
To:     stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

See

    https://bugzilla.kernel.org/show_bug.cgi?id=207561

and the fix seems to be to back-port commit 8623b5255ae7
("drm/scheduler: fix drm_sched_get_cleanup_job").

I think Artem will (has?) make a report too, but I thought I'd just
mention it to make sure since I was on the bugzilla.

                Linus
