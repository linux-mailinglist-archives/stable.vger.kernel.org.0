Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 603A892522
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 15:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbfHSNfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 09:35:34 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44620 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727172AbfHSNfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 09:35:34 -0400
Received: by mail-pf1-f193.google.com with SMTP id c81so1181179pfc.11
        for <stable@vger.kernel.org>; Mon, 19 Aug 2019 06:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=b24y8YNyDakT8Ackw7Z28iXknqt8hTjwSrZovio34cU=;
        b=cdcr4i14+DjbI3LKThO/7RUZYbPlbWsOt75g6pfk/qJ3Z7OijNCN4PYZT+lTDBa5Ez
         pJrlt/SjuzBEvO3NkZfUoUlsS0hUdfgUGpcR5BJefdEYfrQliiChN71mnU35BNwxR4Ka
         yWWin3ELhlNuM9G4+9NTlai3SabhoSuttbC7Lb4We9xLMJIkzMXR0U53MlsHc0+PIRKu
         P6nDkMl848h/DBV0qGMzLTCtqoiDjvlLtcQBOWqLlImJMji990W1COC+hS1/ZunknQjz
         hFVHRSpPTrZUMAETDgK6ENJjfazdw3Y+kDJUolUNQbrNd3/hW+YrZTpRRcWZTiN93z9P
         3Tsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=b24y8YNyDakT8Ackw7Z28iXknqt8hTjwSrZovio34cU=;
        b=WeLQAGtjC6sf6f/pjsVXxcA8U2gjLqd8XgTGcDi55avZHZpJr70ks/TdiBk1tWk323
         AcWocLKRUQeMRzd6d6oYo3u633wBWJMXDf6DVoAErxiczI+uAQzXE/SdOphT5O+rpSu6
         GTVPr3fNvHJz/G5uLRPriRb+E6ER/urlURgTIKeXrVM87kEw6523tK5503qH4i2kTdMB
         c+Y3rDqC57yFZU1VXqflJN0nvdFY1HjZVbDD3jIJeXCc0a6NDFd4Cp9Qz+NM9yU4e2Gy
         97Kd32MNaAgHYUK3p16klytjVTna1INPtBqSgmsY+wKthlptThSvc9X77oT7PaUlAVh2
         oyWA==
X-Gm-Message-State: APjAAAWGNJxhvPe4mKJ+dgUVnhYcJwbuQJIiib903Fk9kJg7vz2scTSE
        9UYnvdZywenP1UGzEvkPkAKjR9Og
X-Google-Smtp-Source: APXvYqwBvVWwvWXn0nkmXnDp7YM8LFA8O2pq5jMYQXq0HjL6NtKcvarbccLwSDRixJV/0YaKnYrTfw==
X-Received: by 2002:a63:3407:: with SMTP id b7mr19909981pga.143.1566221733658;
        Mon, 19 Aug 2019 06:35:33 -0700 (PDT)
Received: from server.roeck-us.net (108-223-40-66.lightspeed.sntcca.sbcglobal.net. [108.223.40.66])
        by smtp.gmail.com with ESMTPSA id l123sm20945032pfl.9.2019.08.19.06.35.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 06:35:32 -0700 (PDT)
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: perf build failures in {v4.4,v4.9,v4.14}.y.queue
Message-ID: <7eb8b107-1fa8-9619-9608-e064c45a2c8d@roeck-us.net>
Date:   Mon, 19 Aug 2019 06:35:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

util/header.c: In function ‘perf_session__read_header’:
util/header.c:2860:10: error: ‘data’ undeclared

Culprit is "perf header: Fix divide by zero error if f_header.attr_size==0".

Fix might be to replace "data->file.path" with "file->path" in the affected
branches.

Guenter
