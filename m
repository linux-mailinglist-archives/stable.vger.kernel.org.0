Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 592866DE90
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbfGSE30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:29:26 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:39024 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730095AbfGSE3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 00:29:25 -0400
Received: by mail-lf1-f50.google.com with SMTP id v85so20744489lfa.6
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 21:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=JT1SvSMRF2bqzpME5XkLZ5TsUTHih+kHfI4N/rNdrGY=;
        b=SNemLonKKZMPYpBIyfikcOSJctcy5St0RQUhVOdz8IIoi3joIGqdzLUfTJ7+nFQ0eq
         ix+AS+E1EPXEzJ0zHL38krbUZXLlOs244vMlWIOzuBOE8KFAP5u6PBTQfV+gJVPNsxpi
         oEC2tU+jBYXIcsNULk/Ca3hAnV1lmTJUuymis=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=JT1SvSMRF2bqzpME5XkLZ5TsUTHih+kHfI4N/rNdrGY=;
        b=iA4OytHPw5qGVdLjcpGJucIuxP4Ccq/iogy3xL5W6xDPP2MelgdXW+Nl2JTjR/beB9
         FAZIw9F1MxQXUnT1Fz57StH372T6JeIwyrj1KXyDaU7T+pZbZc2v0wqTvZ+dqgPHXMss
         zayULk/Hj8QRtwkvG9wI5bJSKN/iPgreLEJr5wvZv2ZrhhEwjSwTR1oHMN9MotZJJWLZ
         4/bFvgIXQKPpdy0bm4ZTbl6/xikYnIKTPW1PJFcN4kpVRdjnNanfiHlh0bTk4nO73fNX
         SXEnJBdyuQ2G6eJV9YDdKggqrXaAnJZMH4D3tNE8oW9tJ/GjoQxlIG602Q31fxVnywqM
         c/YQ==
X-Gm-Message-State: APjAAAXXvulcZtwTDmo/DOAu/U97+mBaGDQbIo2wg+6mM/VIhsMo3elW
        GLrzETYUUQ3OG+EWrtrP2/3sI7rbpuY=
X-Google-Smtp-Source: APXvYqxCtLr1fVuX3PQUMT5XZ1LC1LoPO5u3g7dnBrW2RmAtvWhPFoj8ZGfX6UUYgBFsPVv8+wbCgw==
X-Received: by 2002:ac2:48bc:: with SMTP id u28mr10059956lfg.126.1563510563379;
        Thu, 18 Jul 2019 21:29:23 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id w6sm4265182lff.80.2019.07.18.21.29.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 21:29:22 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id b17so20778144lff.7
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 21:29:22 -0700 (PDT)
X-Received: by 2002:ac2:5c42:: with SMTP id s2mr11932515lfp.61.1563510562381;
 Thu, 18 Jul 2019 21:29:22 -0700 (PDT)
MIME-Version: 1.0
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 18 Jul 2019 21:29:06 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg+aNdzECivhrKrBr8CzEuMuhPg40DcH=jgmNSD+Ns_Fw@mail.gmail.com>
Message-ID: <CAHk-=wg+aNdzECivhrKrBr8CzEuMuhPg40DcH=jgmNSD+Ns_Fw@mail.gmail.com>
Subject: Floppy ioctl range clamping fixes
To:     stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hmm. I just realized when I saw Sasha's autoselect patches flying by
that the floppy ioctl fixes didn't get marked for stable, but they
probably should be.

There's four commits:

  da99466ac243 floppy: fix out-of-bounds read in copy_buffer
  9b04609b7840 floppy: fix invalid pointer dereference in drive_name
  5635f897ed83 floppy: fix out-of-bounds read in next_valid_format
  f3554aeb9912 floppy: fix div-by-zero in setup_format_params

that look like stable material - even if I sincerely hope that the
floppy driver isn't critical for anybody.

I leave it to the stable people to decide if they care. I don't think
the hardware matters any more, but I could imagine that people still
use it for some virtual images and have a floppy device inside a VM
for that reason.

                Linus
