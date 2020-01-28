Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7FA14B3AE
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 12:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgA1Lor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 06:44:47 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35186 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgA1Lor (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 06:44:47 -0500
Received: by mail-lf1-f66.google.com with SMTP id z18so8839407lfe.2
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 03:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=mgusEnhhgtGBvfbhQucaF2KfmVDZ4TjVB24m8QhPj9I=;
        b=yeoe3MB1G5BIGiOY0k8c3msC5eTxjT/aUuuhz1v9akqBT0jjVuz9uZrTDVjjiugmDr
         qMeC4bRzDrwloxLhLbK9t1eVAiiyD5LHjZuaG8RhvQcT1dEFXYndw5Zihfehwd0peKyd
         q89mOjGCswv4ZTgJsRRKTJVgRm/PjzK/ewhw3QDHaPCFoej/Y8aSxTEC7apfE2WGl3EO
         Rs/r+wXE3KwPz9+QHlab/9RbrMuQok/LlWAqDJeMe7kHDLOTixnb5IWdNc6DW7tPYrnP
         EHsCmt/fGD8ADZTBCQmkqFdPjx2H6uXHFuA51zLf7aPxsiFXdGhMMGVPd/93V/vhau4k
         +Uxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=mgusEnhhgtGBvfbhQucaF2KfmVDZ4TjVB24m8QhPj9I=;
        b=JqaUQgUn/sgqRZ1otO5YUE8rTI1d50unyHcCMFeCTdSw1BDh7+9+la0NDPjwqpNKBf
         NOkaUZKWyZKKk/SG19r3ybZNw4+WmHs1h6ZHEfqtlGiv8XYJ2Jrke0a9Djtxywy1z9sq
         i7r31bjI13xHtpsyhXwi3M/XLqu3otOfe0gs+bjVPn/5u07MAOiZY5fgvxpsfbe6oXNy
         7SH6CxBB417VQd0goU5dWw5QWN/7jK1cUKABcC0YOM6g7xVAG7P3gf8vouP2B6/riVHe
         b+Gw4NtwMlBWnJ8sknWutd1E5fd5LJJXZJEI9s74GPl+K+HT9PYcZ1ybq+ZPb8IVZHwS
         Zu0g==
X-Gm-Message-State: APjAAAWbL89Fha6QSnxgm5NqN2I8EAV21JG0fHyqK+sQoeH3YtCDFiNx
        UNu421GQipY/DP+ev3afSZaFZC1VPFOl8+RYhSoCg3pftZc=
X-Google-Smtp-Source: APXvYqxTbOimuZzyUHXNwQtqjr5AOaoCNu6TjWj3czSlP8CPmCLX1FpOzdy9Avd6azFSxwimVgn6P0+j4535iv/prNo=
X-Received: by 2002:ac2:5b41:: with SMTP id i1mr2165066lfp.82.1580211884954;
 Tue, 28 Jan 2020 03:44:44 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 28 Jan 2020 17:14:33 +0530
Message-ID: <CA+G9fYs0hK+WaRwdD+64_15Un6fOdEb-RQH0=jZLwJ49nnKK6A@mail.gmail.com>
Subject: stable-rc 4.9.212-rc1/2e383da55e49: regressions detected in project
 stable v4.9.y on OE
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc 4.9 build failed due to these build error,

drivers/md/bitmap.c:1702:13: error: conflicting types for 'bitmap_free'
 static void bitmap_free(struct bitmap *bitmap)
             ^~~~~~~~~~~
include/linux/bitmap.h:94:13: note: previous declaration of
'bitmap_free' was here
 extern void bitmap_free(const unsigned long *bitmap);
             ^~~~~~~~~~~
scripts/Makefile.build:304: recipe for target 'drivers/md/bitmap.o' failed

suspecting this patch causing this build failure on stable-rc 4.9

bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()
commit c42b65e363ce97a828f81b59033c3558f8fa7f70 upstream.

A lot of code become ugly because of open coding allocations for bitmaps.

Introduce three helpers to allow users be more clear of intention
and keep their code neat.

Note, due to multiple circular dependencies we may not provide
the helpers as inliners. For now we keep them exported and, perhaps,
at some point in the future we will sort out header inclusion and
inheritance.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

-- 
Linaro LKFT
https://lkft.linaro.org
